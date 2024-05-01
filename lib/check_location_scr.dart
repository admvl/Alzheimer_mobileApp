import 'dart:io';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_profile.dart';
import 'package:alzheimer_app1/services/ubicaciones_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';

final usuariosService = UsuariosService();
final ubicacionesService = UbicacionesService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatefulWidget {
  const CheckLocationScr({super.key});

  @override
  _CheckLocationScrState createState() => _CheckLocationScrState();
}

class _CheckLocationScrState extends State<CheckLocationScr> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) => _buildContent(context, snapshot),
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: Center(
          child: Text('Error al obtener el token: ${snapshot.error}'),
        ),
      );
    } else {
      return FutureBuilder<Usuarios>(
        future: usuariosService.obtenerUsuarioPorId(snapshot.data!),
        builder: (context, usuarioSnapshot) {
          if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (usuarioSnapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: Center(
                child: Text('Error al obtener el usuario: ${usuarioSnapshot.error}'),
              ),
            );
          } else {
            final usuario = usuarioSnapshot.data!;
            return _buildUserLocation(context, usuario);
          }
        },
      );
    }
  }
  
  Widget _buildUserLocation(BuildContext context, Usuarios usuario) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ubicación del paciente'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    usuario.idPersona!.nombre!,
                    style: const TextStyle(fontSize: 35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Ubicación',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<Dispositivos>(
              //future: _getDeviceLocation(usuario.idPaciente!),
              future: ubicacionesService.obtenerUbicacion(usuario.idPaciente!),
              builder: (context, deviceSnapshot) {
                if (deviceSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (deviceSnapshot.hasError) {
                  return Center(
                    child: Text('Error al obtener la ubicación del dispositivo: ${deviceSnapshot.error}'),
                  );
                } else {
                  final dispositivo = deviceSnapshot.data!;
                  return SizedBox(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(dispositivo.ubicacion!.latitud!, dispositivo.ubicacion!.longitud!),
                        zoom: 16.0,
                      ),
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      markers: {
                        Marker(
                          markerId: MarkerId('device_marker'),
                          position: LatLng(dispositivo.ubicacion!.latitud!, dispositivo.ubicacion!.longitud!),
                          infoWindow: InfoWindow(
                            title: Text(dispositivo.nombre!),
                          ),
                        ),
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
Future<Dispositivos> _getDeviceLocation(int idPaciente) async {
  // Assuming you have an API endpoint to get device location by patient ID
  final url = 'https://your-api-endpoint.com/pacientes/$idPaciente/dispositivo/ubicacion';

  final response = await http.get(Uri.parse(url),
    headers: {
      'Authorization': 'Bearer ${await tokenUtils.getIdUsuarioToken()}' // Include authorization token
    }
  );

  if (response.statusCode == 200) {
    return Dispositivos.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error getting device location: ${response.statusCode}');
  }
}
*/