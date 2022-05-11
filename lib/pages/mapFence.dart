import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MarkerNotifier extends ChangeNotifier {
  bool isSingle = false;
  Color currentColor = Color.fromRGBO(151, 196, 232, 1);

  List<Marker> markers = [];
  List<LatLng> polyline = [];

  addNewMarker({required LatLng kLatLang}) {
    if (isSingle) markers.clear();
    markers.add(Marker(
        point: kLatLang,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  new SnackBar(content: Text('Marker is clicked')));
            },
            child: CircleAvatar(
              backgroundColor: currentColor,
              radius: 50,
            ),
          );
        }));
    polyline.add(kLatLang);
    notifyListeners();
  }

  setColor({required Color color}) {
    currentColor = color;
  }

  clearAllMarkers() {
    markers.clear();
    polyline.clear();
    notifyListeners();
  }

  deleteMarkers() {
    if (markers.isNotEmpty) {
      markers.removeAt(markers.length - 1);
      polyline.removeAt(polyline.length - 1);
      notifyListeners();
    }
  }

  setMarkerRenderType({required bool single}) {
    isSingle = single;
    notifyListeners();
  }
}

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPage();
  }
}

class _MapPage extends State<MapPage> {
  late MapController _mapController;
  late MarkerNotifier markerNotifier = MarkerNotifier();

  Color currentColor = Color.fromRGBO(151, 196, 232, 1);

  void changeColor(Color color) => setState(() {
        currentColor = color;
        markerNotifier.setColor(color: color);
      });

  @override
  void initState() {
    // intialize the controllers
    _mapController = MapController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (pos, val) {
                setState(
                  () {
                    markerNotifier.addNewMarker(kLatLang: val);
                    print(markerNotifier.markers);
                  },
                );
              },
              plugins: [
                //TappablePolylineMapPlugin(),
              ],
              onMapCreated: (_con) async {},
              onPositionChanged: (position, isChanged) {},
              center: LatLng(45.1313258, 5.5171205),
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              zoom: 17.0,
              minZoom: 2,
              maxZoom: 17.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                retinaMode: true,
              ),
              PolylineLayerOptions(polylines: [
                Polyline(
                  points: markerNotifier.polyline +
                      markerNotifier.polyline.map((e) => e).toList(),
                  // isDotted: true,
                  color: currentColor,
                  strokeWidth: 6,
                )
              ]),
              MarkerLayerOptions(
                markers: markerNotifier.markers,
                rotate: false,
              ),
            ],
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: ClipRRect(
                                      child: Material(
                                        color: Color.fromRGBO(255, 255, 255, 0),
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: SvgPicture.asset(
                                              "assets/images/close.svg",
                                              color: Color.fromRGBO(
                                                  74, 85, 104, 1),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    )),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          height: 48,
                          width: 240,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Virtual Fence",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(74, 85, 104, 1),
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 24,
                                  width: 24,
                                  child: ClipRRect(
                                    child: Material(
                                      color: Color.fromRGBO(255, 255, 255, 0),
                                      child: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: SvgPicture.asset(
                                            "assets/images/menu.svg",
                                            color:
                                                Color.fromRGBO(74, 85, 104, 1),
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Create Name',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            74, 85, 104, 1),
                                                        fontSize: 23,
                                                        fontFamily: 'Open Sans',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          'Are you sure you want to delete the pet? This action cannot be undone!',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    79,
                                                                    79,
                                                                    79,
                                                                    1),
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                      SizedBox(
                                                        height: 16,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          //controller: _emailController,
                                                          obscureText: false,
                                                          /*validator: (email) {
                                                        if (isEmailValid(email!))
                                                          return null;
                                                        else
                                                          return 'Enter a valid email';
                                                      },*/
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        15.0,
                                                                    horizontal:
                                                                        10.0),
                                                            labelText:
                                                                'Name Fence',
                                                            labelStyle: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          114,
                                                                          117,
                                                                          168,
                                                                          0.5)),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          114,
                                                                          117,
                                                                          168,
                                                                          1)),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          251,
                                                                          76,
                                                                          31,
                                                                          1)),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          251,
                                                                          76,
                                                                          31,
                                                                          1)),
                                                            ),
                                                            errorStyle: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        251,
                                                                        76,
                                                                        31,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .auto,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      color: Colors.green,
                                                      textColor: Colors.white,
                                                      child: Text('SAVE'),
                                                      onPressed: () {
                                                        setState(() {
                                                          //codeDialog = valueText;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      titlePadding: const EdgeInsets.all(5.0),
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      content: SingleChildScrollView(
                                          child: HueRingPicker(
                                        pickerColor: currentColor,
                                        onColorChanged: changeColor,
                                        enableAlpha: false,
                                        displayThumbColor: false,
                                      )
                                          /*ColorPicker(
                                          pickerColor: currentColor,
                                          onColorChanged: changeColor,
                                          colorPickerWidth: 300.0,
                                          pickerAreaHeightPercent: 0.7,
                                          enableAlpha: true,
                                          displayThumbColor: true,
                                          showLabel: false,
                                          paletteType: PaletteType.rgbWithBlue,
                                          pickerAreaBorderRadius: const BorderRadius.only(
                                            topLeft: const Radius.circular(12.0),
                                            topRight: const Radius.circular(12.0),
                                            bottomLeft: const Radius.circular(12.0),
                                            bottomRight: const Radius.circular(12.0),
                                          ),
                                        ),*/
                                          ));
                                },
                              );
                            });
                          },
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/ellipse.svg",
                                  color: currentColor,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Color"),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              markerNotifier.deleteMarkers();
                            });
                          },
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/circle-slashed.svg",
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Delete"),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              markerNotifier.clearAllMarkers();
                            });
                          },
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/trash.svg",
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Clear"),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              markerNotifier.clearAllMarkers();
                            });
                          },
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/check-circle.svg",
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Save"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
