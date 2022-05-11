import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/data/repositories/pet_repository.dart';

import '../data/model/pet.dart';

class MapOnePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapOnePage();
  }
}

class _MapOnePage extends State<MapOnePage> {
  late MapController _mapController;
  var index;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  Widget build(BuildContext context) {
    index = ModalRoute.of(context)!.settings.arguments as int;
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) => PetBloc(
          petRepository: PetRepository(),
        )..add(LoadPet()),
        child: Scaffold(
          body: Stack(
            children: [
              BlocBuilder<PetBloc, PetState>(builder: (context, state) {
                if (state is PetLoaded) {
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      controller: _mapController,
                      center: LatLng(state.pets.elementAt(index).latitude!, state.pets.elementAt(index).longitude!),
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
                        retinaMode: true,
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(state.pets.elementAt(index).latitude!, state.pets.elementAt(index).longitude!),
                            builder: (ctx) => Container(
                              child: FlutterLogo(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
