//Version OK

import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';

final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final geocercaService = GeocercasService();
final dispositivoService = DispositivosService();
final tokenUtils = TokenUtils();

class UpdateGeocerca extends StatefulWidget {
  final Pacientes? paciente;
  const UpdateGeocerca({
    super.key, required this.paciente
  });

  @override
  _UpdateGeocercaState createState() => _UpdateGeocercaState();
}

class _UpdateGeocercaState extends State<UpdateGeocerca> {
  String? dispositivoPacienteId;
  String? geocercaId;
  late LatLng geofenceCenter = const LatLng(0, 0);
  GoogleMapController? mapController;
  TextEditingController addressController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  Set<Marker> markers = {};
  Circle? geofenceCircle;
  PacientesService _pacientesService = PacientesService();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        geofenceCenter = LatLng(position.latitude, position.longitude);
        mapController
            ?.animateCamera(CameraUpdate.newLatLngZoom(geofenceCenter, 20.0));
      });
    }
  }

  Future<void> _onMapTap(LatLng position) async {
    if (mapController != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId('marker_id'),
              position: position,
              infoWindow: InfoWindow(
                  title: 'Marcador', snippet: placemark.street ?? ''),
            ),
          );
          addressController.text = placemark.street ?? '';
        });
      }
    } else {
      _showErrorSnackBar('Error al configurar dirección');
    }
  }

  void _updateGeofenceCircle(Geocerca geocerca) {
    if (mapController != null && markers.isNotEmpty) {
      LatLng markerPosition = markers.first.position;
      double radius = double.tryParse(radiusController.text) ?? 0;
      if (radius > 15 && radius < 45) {
        setState(() {
          geocerca = Geocerca(
            idGeocerca: geocercaId,
            radioGeocerca: radius,
            fecha: DateTime.now(),
            latitude: markerPosition.latitude,
            longitude: markerPosition.longitude,
          );

          geofenceCircle = Circle(
            circleId: const CircleId('geofence_circle'),
            center: markerPosition,
            radius: radius,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeWidth: 2,
            strokeColor: Colors.blue,
          );
        });
        geocercaService.actualizarGeocerca(geocerca.idGeocerca!, geocerca);
      } else {
        _showErrorSnackBar('Error al configurar Geocerca: Ingrese valores entre 15m y 45m');
      }
    } else {
      _showErrorSnackBar('Error al configurar y actualizar zona segura');
    }
  }

  
  Future<void> _createGeofenceCircle(String? dispositivoPacienteId) async {
    if (mapController != null && markers.isNotEmpty) {
      LatLng markerPosition = markers.first.position;
      double radius = double.tryParse(radiusController.text) ?? 0;
      if (radius > 15 && radius < 45) {
        final nuevaGeocerca = Geocerca(
          radioGeocerca: radius,
          fecha: DateTime.now(),
          latitude: markerPosition.latitude,
          longitude: markerPosition.longitude,
        );
        try {
          Geocerca geocercaCreada =
              await geocercaService.crearGeocerca(nuevaGeocerca);
          setState(() {
            geocercaId = geocercaCreada.idGeocerca;
            geofenceCircle = Circle(
              circleId: const CircleId('geofence_circle'),
              center: markerPosition,
              radius: radius,
              fillColor: Colors.blue.withOpacity(0.3),
              strokeWidth: 2,
              strokeColor: Colors.blue,
            );
          });
          final dispositivo = Dispositivos(
            idDispositivo: dispositivoPacienteId,
            idGeocerca: geocercaCreada,
          );
          await dispositivoService.actualizarDispositivos(
              dispositivo.idDispositivo!, dispositivo);
        } catch (e) {
          _showErrorSnackBar('Error al actualizar dispositivo con geocerca : $e');
        }
      } else{
        _showErrorSnackBar('Error al configurar Geocerca: Ingrese valores entre 15m y 45m');
      }
    } else {
      _showErrorSnackBar('Error al obtener el usuario');
    }
  }

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zona Segura'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSnackBar(String content) {
    return SnackBar(content: Text(content));
  }

  void _showErrorSnackBar(String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      //builder: (context, snapshot) => _buildContent(context, snapshot),
      builder: (context, snapshot) => _buildLocationWidget(context),
    );
  }
  
  Widget _buildLocationWidget(BuildContext context) {
          dispositivoPacienteId = widget.paciente?.idDispositivo.idDispositivo!;
          geocercaId = widget.paciente?.idDispositivo.idGeocerca?.idGeocerca;
          if (geocercaId != null) {
            return FutureBuilder<Geocerca>(
                future: geocercaService.obtenerGeocerca(geocercaId!),
                builder: (context, geocercaSnapshot) {
                  if (geocercaSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildCircularProgressIndicator();
                  } else if (geocercaSnapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error al obtener la zona segura: ${geocercaSnapshot.error}'),
                    );
                  } else {
                    final geocerca = geocercaSnapshot.data!;
                    double radius = geocerca.radioGeocerca ?? 0;
                    if (radius > 0) {
                      geofenceCircle = Circle(
                        circleId: const CircleId('geofence_circle'),
                        center:
                            LatLng(geocerca.latitude, geocerca.longitude),
                        radius: radius,
                        fillColor: Colors.blue.withOpacity(0.3),
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                      );
                    }
                    geofenceCenter = LatLng(geocerca.latitude, geocerca.longitude);
                    return Scaffold(
                      appBar: _buildAppBar('Zona Segura'),
                      body: _buildMapWidget(geofenceCenter),
                    );
                  }
                });
          } else {
            return Scaffold(
              appBar: _buildAppBar('Zona Segura'),
              body: _buildMapWidget(geofenceCenter),
            );
          }
  }

  Widget _buildMapWidget(LatLng targetPosition) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: targetPosition,
            zoom: 19,
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          onTap: _onMapTap,
          markers: markers,
          circles: geofenceCircle != null ? {geofenceCircle!} : Set(),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: radiusController,
                decoration: const InputDecoration(
                  labelText: 'Radio (metros)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (geocercaId != null) {
                    geocercaService.obtenerGeocerca(geocercaId!).then((geocerca) {
                      _updateGeofenceCircle(geocerca);
                    });
                  } else {
                    _createGeofenceCircle(dispositivoPacienteId);
                  }
                },
                child: const Text('Establecer geocerca'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
