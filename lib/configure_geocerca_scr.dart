//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckGeocercaScr extends StatelessWidget{
  const CheckGeocercaScr({super.key});

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.504711, -99.144362),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configuración de Zona Segura'),
      ),
      body: 
      Center(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              child: Text("Ajusta la ubicación de la zona segura",
                style: TextStyle(
                  fontSize: 16.0, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (normal, negrita, etc.)
                  color: Colors.blue, // Color del texto
                  fontStyle: FontStyle.italic, // Estilo de la fuente (cursiva)
                  decoration: TextDecoration.underline, // Decoración del texto (subrayado)
                ),
              ),
            ),
            SizedBox(
              width: 500,
              height: 300,
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

