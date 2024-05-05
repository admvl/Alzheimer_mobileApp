
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/ubicaciones_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';

final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final ubicacionesService = UbicacionesService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatefulWidget {
  const CheckLocationScr({super.key});

  @override
  _CheckLocationScrState createState() => _CheckLocationScrState();
}

class _CheckLocationScrState extends State<CheckLocationScr> {
  String? dispositivoPacienteId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) => _buildContent(context, snapshot),
    );
  }
  Widget _buildLocationWidget(BuildContext context, Usuarios usuario) {
    return FutureBuilder<Pacientes>(
      future: pacientesService.obtenerPacientePorId(usuario.idUsuario!),
      builder: (context, pacienteSnapshot) {
        if (pacienteSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (pacienteSnapshot.hasError) {
          return Center(
            child: Text('Error al obtener el paciente: ${pacienteSnapshot.error}'),
          );
        } else {
          final paciente = pacienteSnapshot.data!;
          dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
          // Ahora, en lugar de devolver directamente el contenido del segundo FutureBuilder,
          // retornaremos otro FutureBuilder que dependa del resultado del primero.
          return FutureBuilder<Ubicaciones>(
            future: ubicacionesService.obtenerUbicacion(dispositivoPacienteId!),
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
                      target: LatLng(dispositivo.latitude, dispositivo.longitude),
                      zoom: 16.0,
                    ),
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                        markerId: const MarkerId('device_marker'),
                        position: LatLng(dispositivo.latitude, dispositivo.longitude),
                        infoWindow: InfoWindow(
                          title: dispositivo.idDispositivo,
                        ),
                      ),
                    },
                  ),
                );
              }
            },
          );
        }
      },
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
            return _buildLocationWidget(context, usuario);
          }
        },
      );
    }
  }

}

