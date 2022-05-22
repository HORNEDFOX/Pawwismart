import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/fence/fence_bloc.dart';
import '../bloc/petBloc/pet_bloc.dart';
import '../data/model/fence.dart';
import '../data/repositories/fence_repository.dart';
import '../data/repositories/pet_repository.dart';

class VirtualFencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FenceRepository(),
      child: BlocProvider(
        create: (context) =>
        FenceBloc(
          fenceRepository: FenceRepository(),
        )
          ..add(LoadFences(FirebaseAuth.instance.currentUser!.uid)),
        child: Scaffold(
          appBar: AppBar(
            // <-- app bar for logo
            toolbarHeight: 0,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(74, 85, 104, 1),
          ),
          body: Container(
            child: Column(
              children: [
                FencesCard(),
                BlocBuilder<FenceBloc, FenceState>(builder: (context, state) {
                  if (state is FenceLoaded) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1.25,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemCount: state.fence.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return FenceCard(
                                fence: state.fence.elementAt(index),
                              );
                            }),
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FencesCard extends StatelessWidget {
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
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fitWidth,
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    color: Color.fromRGBO(255, 255, 255, 0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset("assets/images/close.svg"),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )),
            Container(
              height: 55,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("Virtual Fences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text("Your virtual pet fences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 5,
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

class FenceCard extends StatelessWidget {
  Fence fence;
  final settings = RestrictedAmountPositions(
    maxAmountItems: 4,
    maxCoverage: 0.5,
    minCoverage: 0.2,
  );

  FenceCard({required this.fence});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) =>
            PetBloc(
              petRepository: PetRepository(),
            )..add(LoadPetsFence(fence.pets!)),
        child: Card(
          color: Colors.white,
          elevation: 5.0,
          shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            child: BlocBuilder<PetBloc, PetState>(builder: (context, state) {
              if (state is PetLoaded) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: fence.color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          )
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${fence.name}", style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w900,
                            )),
                            Container(
                                //padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child:
                                        SvgPicture.asset("assets/images/menu.svg", color: Color.fromRGBO(255, 255, 255, 0.5),),
                                      ),
                                      onTap: () {
                                      },
                                      //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftJoined, child: const SettingApp()));
                                      // },
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        ),
                      ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pets using the fence", style: TextStyle(
                          color: Color.fromRGBO(148, 161, 187, 1),
                          fontSize: 13,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                        SizedBox(height: 3,),
                        AvatarStack(
                          settings: settings,
                          height: 35,
                          avatars: [
                            for (var n = 0; n < state.pets.length; n++)
                              NetworkImage('${state.pets.elementAt(n).image}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])
                );
              }
              return Container(
                child: Text('hghg'),
              );
            }
            ),
          ),
        ),
      ),
    );
  }
}
