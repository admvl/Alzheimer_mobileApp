//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MaterialApp(
    home: CheckLocationScr(),
  ));
}


class CheckLocationScr extends StatelessWidget{
  const CheckLocationScr({super.key});

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.504711, -99.144362),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ubicación del paciente'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}

