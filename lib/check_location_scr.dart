/* Version OK
import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
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
final geocercaService = GeocercasService();
final ubicacionesService = UbicacionesService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatefulWidget {
  const CheckLocationScr({super.key});

  @override
  _CheckLocationScrState createState() => _CheckLocationScrState();
}

class _CheckLocationScrState extends State<CheckLocationScr> {
  String? dispositivoPacienteId;
  String? geocercaId;
  PacientesService _pacientesService = PacientesService();
  String? nombrePaciente;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el ID del usuario
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error al obtener el ID del usuario, muestra un mensaje de error
          return SnackBar(
            content: Text('Error: ${snapshot.error}'),
          );
        }else {
          // Cuando se obtiene el ID del usuario, muestra el diálogo para seleccionar al paciente
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }
  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      // Utiliza un contenedor personalizado en lugar de AlertDialog
      child: SingleChildScrollView(
        child:Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Elige al paciente:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder(
                future: _pacientesService.obtenerPacientesPorId(idUsuario!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return SnackBar(content: Text('${snapshot.error}'));
                    //return Text('Error: ${snapshot.error}');
                  } else {
                    final List<Pacientes> pacientes = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: pacientes.length,
                      itemBuilder: (context, index) {
                        final paciente = pacientes[index];
                        return ListTile(
                          title: Text('${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => _buildLocationWidget(context,paciente),
                              ),
                            );
                            //_buildForm;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(paciente.idPersona.nombre),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      )
    );
  }
  
  Widget _buildLocationWidget(BuildContext context, Pacientes paciente) {
    nombrePaciente = '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}';
    return FutureBuilder<Ubicaciones>(
      future: ubicacionesService.obtenerUbicacionActualizada(paciente.idDispositivo.idDispositivo!),
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
          dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
          geocercaId = paciente.idDispositivo.idGeocerca?.idGeocerca;
          return FutureBuilder<Geocerca>(
            future: geocercaService.obtenerGeocerca(geocercaId!),
            builder: (context, geocercaSnapshot) {
              if (geocercaSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (geocercaSnapshot.hasError) {
                return Center(
                  child: Text('Error al obtener la zona segura: ${geocercaSnapshot.error}'),
                );
              } else {
                final geocerca = geocercaSnapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(dispositivo.latitude, dispositivo.longitude),
                              zoom: 19,
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
                            circles: _createCircles(paciente, geocerca),
                            //circles: Set<Circle>.from(_createCircles(paciente)),
                            //circles: Set.of(_createCircles(paciente) as Iterable<Circle>),
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
                                      '${nombrePaciente} ${dispositivo.fechaHora}',
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

  Set<Circle> _createCircles(Pacientes paciente, Geocerca geocerca) {
  dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
  geocercaId = paciente.idDispositivo.idGeocerca?.idGeocerca;
  return {
    Circle(
      circleId: const CircleId('circle_id'),
      center: LatLng(geocerca.latitude, geocerca.longitude),
      radius: geocerca.radioGeocerca,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeWidth: 2,
      strokeColor: Colors.blue,
    ),
  };
}
}*/


import 'dart:async';
import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
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
final geocercaService = GeocercasService();
final ubicacionesService = UbicacionesService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatefulWidget {
  const CheckLocationScr({super.key});

  @override
  _CheckLocationScrState createState() => _CheckLocationScrState();
}

class _CheckLocationScrState extends State<CheckLocationScr> {
  String? dispositivoPacienteId;
  String? geocercaId;
  PacientesService _pacientesService = PacientesService();
  String? nombrePaciente;
  Timer? _locationTimer;
  Ubicaciones? _currentUbicacion;

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el ID del usuario
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error al obtener el ID del usuario, muestra un mensaje de error
          return SnackBar(
            content: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Cuando se obtiene el ID del usuario, muestra el diálogo para seleccionar al paciente
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      // Utiliza un contenedor personalizado en lugar de AlertDialog
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige al paciente:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _pacientesService.obtenerPacientesPorId(idUsuario!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return SnackBar(content: Text('${snapshot.error}'));
                  //return Text('Error: ${snapshot.error}');
                } else {
                  final List<Pacientes> pacientes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return ListTile(
                        title: Text('${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _buildLocationWidget(context, paciente),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(paciente.idPersona.nombre),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationWidget(BuildContext context, Pacientes paciente) {
    nombrePaciente = '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}';
    dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
    geocercaId = paciente.idDispositivo.idGeocerca?.idGeocerca;
    
    // Inicia el temporizador para actualizar la ubicación
    _startLocationTimer(paciente.idDispositivo.idDispositivo!);
    
    return FutureBuilder<Ubicaciones>(
      future: ubicacionesService.obtenerUbicacionActualizada(paciente.idDispositivo.idDispositivo!),
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
          _currentUbicacion = deviceSnapshot.data;
          return FutureBuilder<Geocerca>(
            future: geocercaService.obtenerGeocerca(geocercaId!),
            builder: (context, geocercaSnapshot) {
              if (geocercaSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (geocercaSnapshot.hasError) {
                return Center(
                  child: Text('Error al obtener la zona segura: ${geocercaSnapshot.error}'),
                );
              } else {
                final geocerca = geocercaSnapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_currentUbicacion!.latitude, _currentUbicacion!.longitude),
                              zoom: 19,
                            ),
                            myLocationButtonEnabled: true,
                            mapType: MapType.normal,
                            markers: {
                              Marker(
                                markerId: const MarkerId('device_marker'),
                                position: LatLng(_currentUbicacion!.latitude, _currentUbicacion!.longitude),
                                infoWindow: InfoWindow(
                                  title: _currentUbicacion!.idDispositivo,
                                ),
                              ),
                            },
                            circles: _createCircles(paciente, geocerca),
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
                              child: Row(
                                children: [
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      '$nombrePaciente ${_currentUbicacion!.fechaHora}',
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

  void _startLocationTimer(String dispositivoId) {
    const duration = Duration(seconds: 10); // Intervalo de tiempo para actualizar la ubicación
    _locationTimer?.cancel(); // Cancela cualquier temporizador previo
    _locationTimer = Timer.periodic(duration, (Timer timer) async {
      try {
        Ubicaciones updatedUbicacion = await ubicacionesService.obtenerUbicacionActualizada(dispositivoId);
        setState(() {
          _currentUbicacion = updatedUbicacion;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la ubicación: $error')),
        );
      }
    });
  }

  Set<Circle> _createCircles(Pacientes paciente, Geocerca geocerca) {
    return {
      Circle(
        circleId: const CircleId('circle_id'),
        center: LatLng(geocerca.latitude, geocerca.longitude),
        radius: geocerca.radioGeocerca,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 2,
        strokeColor: Colors.blue,
      ),
    };
  }
}

