//import 'dart:io';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
/*
void main() {
  runApp(const MaterialApp(
    home: CheckLocationScr(),
  ));
}*/


class CheckLocationScr extends StatelessWidget{
  const CheckLocationScr({super.key});

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.504711, -99.144362),
  );
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuarios>(
      future: tokenUtils.getIdUsuarioToken().then((usuarioId) => UsuariosService.obtenerUsuarioPorId(usuarioId)),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          Usuarios usuario = snapshot.data!;
          Ubicaciones? ubicacion = usuario.ubicaciones?.first;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Ubicación del paciente'),
            ),
            body: 
            Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Usuario: ${usuario.idPersona!.nombre}",
                        style: TextStyle(
                          fontSize: 16.0, // Tamaño de la fuente
                          fontWeight: FontWeight.bold, // Peso de la fuente (normal, negrita, etc.)
                          //color: Colors.blue, // Color del texto
                          //fontStyle: FontStyle.italic, // Estilo de la fuente (cursiva)
                          //decoration: TextDecoration.underline, // Decoración del texto (subrayado)
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ubicación Actual: $ubicacion.ubicacion",
                        style: TextStyle(
                          fontSize: 16.0, // Tamaño de la fuente
                          fontWeight: FontWeight.bold, // Peso de la fuente (normal, negrita, etc.)
                          //color: Colors.blue, // Color del texto
                          //fontStyle: FontStyle.italic, // Estilo de la fuente (cursiva)
                          //decoration: TextDecoration.underline, // Decoración del texto (subrayado)
                        ),
                      ),
                    ),
                  ],
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
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

