//import 'dart:io';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';


final usuariosService = UsuariosService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatelessWidget {
  const CheckLocationScr({super.key});

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.504711, -99.144362),
  );


  Widget _buildContent(BuildContext context,AsyncSnapshot<String> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting)
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else if(snapshot.hasError)
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: Center(
          child: Text('Error al obtener el token: ${snapshot.error}'),
        ),
      );
    }else{
      return FutureBuilder<Usuarios>(
        future:usuariosService.obtenerUsuarioPorId(snapshot.data!),
        builder: (context,usuarioSnapshot){
          if(usuarioSnapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else if(usuarioSnapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: Center(
                child: Text('Error al obtener el usuario: ${usuarioSnapshot.error}'),
              ),
            );
          }else{
            final usuario = usuarioSnapshot.data!;
            return _buildUserLocation(context, usuario);
          }
        },
      );
    }
  }
  
  @override
  Widget _buildUserLocation(BuildContext context, Usuarios usuario) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ubicación del paciente'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  //UserName,
                  usuario.idPersona!.nombre,
                  style: const TextStyle(fontSize: 35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  //Ubicacion
                  usuario.idPersona!.nombre,

                  style: const TextStyle(fontSize: 35),
                  /*
                  style: TextStyle(
                    fontSize: 16.0, // Tamaño de la fuente
                    fontWeight: FontWeight.bold, // Peso de la fuente (normal, negrita, etc.)
                  ),*/
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
  }

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: _buildContent,
    );
  }
}
