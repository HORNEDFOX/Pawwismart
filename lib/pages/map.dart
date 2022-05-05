import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MarkerNotifier extends ChangeNotifier{
  bool isSingle = false;

  List<Marker> markers = [];
  List<LatLng> polyline = [];

  addNewMarker({required LatLng kLatLang})
  {
    if(isSingle) markers.clear();
    markers.add(Marker(
        point: kLatLang,
        builder: (context){
          return GestureDetector(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(content: Text('Marker is clicked')));
            },
            child: CircleAvatar(
              backgroundColor: Colors.indigo,
              radius: 70,
            ),
          );
        }));
    polyline.add(kLatLang);
    notifyListeners();
  }

  clearAllMarkers(){
    markers.clear();
    polyline.clear();
    notifyListeners();
  }

  setMarkerRenderType({required bool single}){
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
  MapController _mapController = MapController();
  MarkerNotifier markerNotifier = MarkerNotifier();

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
          onTap: (pos, val){
      setState(() {
        markerNotifier.addNewMarker(kLatLang: val);
        print(markerNotifier.markers);
      },
      );
          },
          plugins: [
            //TappablePolylineMapPlugin(),
          ],
          onMapCreated: (_con) async{},
          onPositionChanged: (position, isChanged){},
          center: LatLng(45.1313258, 5.5171205),
          zoom: 17.0,
          maxZoom: 17.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            retinaMode: true,
          ),
          PolylineLayerOptions(polylines: [
            Polyline(
              points: markerNotifier.polyline+markerNotifier.polyline.map((e) => e).toList(),
              // isDotted: true,
              color: Color(0xFF669DF6),
              strokeWidth: 6,
            )
          ]),
          MarkerLayerOptions(
            markers: markerNotifier.markers,
            rotate: false,
          ),
        ],
      ),
          SafeArea(child:
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          MaterialButton(
            color: MarkerNotifier().isSingle ? Colors.red : Colors.indigo,
            onPressed: (){
              markerNotifier.setMarkerRenderType(single: false);
            },
            child: Text("Multiple"),
          ),
          ElevatedButton(
            onPressed: (){
    setState(() {
      markerNotifier.clearAllMarkers();
    },
    );
            },
            child: Text("Clear"),
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
