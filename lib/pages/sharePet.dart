import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SharePetPage extends StatelessWidget {
  const SharePetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            // <-- app bar for logo
            toolbarHeight: 0,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(74, 85, 104, 1),
          ),
      body: Container(
        child: Column(
          children: [
            PetCard(),
        ShareCard(),
            ShareCard(),
            ShareCard(),
          ],
        ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        elevation: 0,
        backgroundColor: Color.fromRGBO(151, 196, 232, 1),
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(100.0))),
        child: SvgPicture.asset("assets/images/plus.svg", height: 30, color: Colors.white,),
      ),
    );
  }
}

class PetCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/avatarDog1.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    color: Color.fromRGBO(255, 255, 255, 0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset(
                            "assets/images/close.svg"),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
            ),
            Container(
              height: 55,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("Share OLIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text("Делись контактами питомца Olive с друзьями!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 10,
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

class ShareCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("James",
                        style: TextStyle(
                          color: Color.fromRGBO(74, 85, 104, 1),
                          fontSize: 23,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text("Jamesjohn@gmail.com",
                        style: TextStyle(
                          color: Color.fromRGBO(74, 85, 104, 1),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 0,
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
