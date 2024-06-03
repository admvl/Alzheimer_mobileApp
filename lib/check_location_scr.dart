import 'dart:async';
import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
import 'package:alzheimer_app1/services/location_provider.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/ubicaciones_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:profile_view/profile_view.dart';
import 'package:provider/provider.dart';

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
  GoogleMapController? _mapController;
  Circle? _deviceCircle;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
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
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  final List<Pacientes> pacientes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return ListTile(
                        title: Text(
                          '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}',
                        ),
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
                    Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        final locationData = locationProvider.locationData;
                        if (locationData != null) {
                          _updateCirclePosition(locationData.latitude, locationData.longitude);
                        }
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(locationProvider.locationData?.latitude ?? 0, locationProvider.locationData?.longitude ?? 0),
                            zoom: 19,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                          markers: {
                            if (locationData != null)
                              Marker(
                                markerId: const MarkerId('device_marker'),
                                position: LatLng(locationData.latitude, locationData.longitude),
                                infoWindow: InfoWindow(
                                  title: dispositivoPacienteId,
                                ),
                              ),
                          },
                          circles: _createCircles(paciente, geocerca)
                            ..addAll(_deviceCircle != null ? {_deviceCircle!} : {}),
                        );
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
                        child: Row(
                          children: [
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '$nombrePaciente ${Provider.of<LocationProvider>(context).locationData?.fechaHora ?? ''}',
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
              ),
            ],
          );
        }
      },
    );
  }

  void _updateCirclePosition(double latitude, double longitude) {
    if (mounted) {
      setState(() {
        _deviceCircle = Circle(
          circleId: const CircleId('device_circle'),
          center: LatLng(latitude, longitude),
          radius: 10,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        );
      });
    }
  }

  Set<Circle> _createCircles(Pacientes paciente, Geocerca geocerca) {
    return {
      Circle(
        circleId: const CircleId('geofence_circle'),
        center: LatLng(geocerca.latitude, geocerca.longitude),
        radius: geocerca.radioGeocerca,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 2,
        strokeColor: Colors.blue,
      ),
    };
  }
}
