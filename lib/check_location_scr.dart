
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/ubicaciones_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:profile_view/profile_view.dart';

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
  String? nombrePaciente;
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
          nombrePaciente = "${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}";
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
                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
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
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: AppBar(
                              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                              title: const Text('Ubicación del paciente'),
                            ),
                          ),
                          Positioned(
                            top: 85,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Center(
                                child: CircularProfileAvatar(
                                  'hbv,v.jbhb n',
                                  borderColor: Theme.of(context).colorScheme.inversePrimary,
                                  borderWidth: 2,
                                  elevation: 5,
                                  radius: 50,
                                  child: const ProfileView(
                                    image: NetworkImage(
                                      "https://images.unsplash.com/photo-1566616213894-2d4e1baee5d8?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 200,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row( //const
                                children: [
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      nombrePaciente ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(

                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis, 
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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

