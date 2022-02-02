import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/pages/flexiableappbar.dart';


class Home extends StatefulWidget{

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {

  List Name = ["Togo", "Olive", "Charlie", "Espresso", "Togo", "Olive", "Charlie", "Espresso"];
  List DeviceID = ["Device ID875905", "Device ID875869", "Device ID805869", "Device ID805869", "Device ID875905", "Device ID875869", "Device ID805869", "Device ID805869"];
  List ImagePet = ["assets/images/avatarDog.jpg", "assets/images/avatarDog1.jpg", "assets/images/avatarDog2.jpg", "assets/images/avatarCat.jpg", "assets/images/avatarDog.jpg", "assets/images/avatarDog1.jpg", "assets/images/avatarDog2.jpg", "assets/images/avatarCat.jpg"];
  var top = 0.0;

  late ScrollController _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }


  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }


  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar( // <-- app bar for logo
            toolbarHeight: 0,
            floating: false,
            pinned: true,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(74, 85, 104, 1),
          ),
          SliverAppBar( // <-- app bar for logo
              toolbarHeight: 110,
              floating: false,
              pinned: false,
              elevation: 0.0,
              backgroundColor: isShrink ? Color.fromRGBO(74, 85, 104, 1) : Color.fromRGBO(253, 253, 253, 1),
              flexibleSpace:
              FlexibleSpaceBar(
                background: FlexiableAppBar(),
              )
          ),
          SliverAppBar( // <-- app bar for custom sticky menu
            primary: true,
            toolbarHeight: 15,
            floating: false,
            pinned: true,
            elevation: 0.0,
            //floating: false,
            backgroundColor: isShrink ? Color.fromRGBO(74, 85, 104, 1) : Color.fromRGBO(253, 253, 253, 1),
            flexibleSpace:
            Container(
              padding: isShrink ? const EdgeInsets.fromLTRB(15,0,0,12): const EdgeInsets.fromLTRB(15,0,0,8),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(color: isShrink ? Color.fromRGBO(74, 85, 104, 1) : Color.fromRGBO(253, 253, 253, 1)),
              child: Row(
                children: [
                  Text('My Pets',
                      style: TextStyle(
                        color: isShrink ? Color.fromRGBO(253, 253, 253, 1): Color.fromRGBO(74, 85, 104, 1),
                        fontSize: isShrink ? 24: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,)
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        width: 30,
                        height: 25,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isShrink ? Color.fromRGBO(86, 98, 120, 1) : Color.fromRGBO(243, 246, 251, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text("89",
                                style: TextStyle(
                                  color:  isShrink ? Color.fromRGBO(243, 246, 251, 1) : Color.fromRGBO(148, 161, 187, 1),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,)),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return PetCard(Name[index], DeviceID[index], ImagePet[index]);
              },
              childCount: Name.length,
            ),
          ),
        ],
      ),);
  }
}


class PetCard extends StatelessWidget {

  late String Name;
  late String DeviceID;
  late String ImagePet;

  PetCard(String Name, String DeviceID, String ImagePet){
    this.Name = Name;
    this.DeviceID = DeviceID;
    this.ImagePet = ImagePet;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15,0,15,10),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage(ImagePet),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 95,
              padding: const EdgeInsets.fromLTRB(15,0,0,0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    width: 225,
                    child: Row(
                      children: <Widget> [
                        Container(
                          width: 197,
                          child: Text(Name,
                              style: TextStyle(
                                color: Color.fromRGBO(74, 85, 104, 1),
                                fontSize: 23,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w900,)),
                        ),
                        Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child : Material(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                child : InkWell(
                                  child : Padding(
                                    padding : const EdgeInsets.all(2),
                                    child : SvgPicture.asset(
                                        "assets/images/filterBig.svg"
                                    ),
                                  ),
                                  onTap : () {},
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 225,
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                    child: Text("111 57 Stockholm 4 mins ago",
                        style: TextStyle(
                          color: Color.fromRGBO(79, 79, 79, 1),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,)),
                  ),
                  Container(
                    width: 225,
                    height: 10,
                  ),
                  Container(
                    width: 225,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 246, 251, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(DeviceID,
                              style: TextStyle(
                                color: Color.fromRGBO(148, 161, 187, 1),
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w400,)),
                        ),
                        Container(
                          width: 31,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                          child: SvgPicture.asset(
                              "assets/images/NSLight.svg"
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0,0,3,0),
                          child: SvgPicture.asset(
                              "assets/images/batteryLight.svg"
                          ),
                        ),
                        Container(
                          child: Text("50%",
                              style: TextStyle(
                                color: Color.fromRGBO(148, 161, 187, 1),
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w400,)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ); // <== The Card class constructor
  }
}


