import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final geocercaService = GeocercasService();
final dispositivoService = DispositivosService();
final tokenUtils = TokenUtils();

/*
void main() => runApp(
  const MaterialApp(
    home: UpdateGeocerca()
  )
);*/

class UpdateGeocerca extends StatefulWidget {
  const UpdateGeocerca({super.key});

  @override
  _UpdateGeocercaState createState() => _UpdateGeocercaState();
}

class _UpdateGeocercaState extends State<UpdateGeocerca> {
  String? dispositivoPacienteId;
  String? geocercaId;
  String? nombrePaciente;

  //late GoogleMapController? mapController;
  GoogleMapController? mapController;
  LatLng initialCameraPosition = const LatLng(0, 0);
  TextEditingController addressController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  Set<Marker> markers = {};
  Circle? geofenceCircle;
  late LatLng geofenceCenter = const LatLng(0,0);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
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
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(geofenceCenter, 20.0));
      });
    }
  }

  void _onMapTap(LatLng position) async {
    if (mapController != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId('marker_id'),
              position: position,
              infoWindow: InfoWindow(title: 'Marcador', snippet: placemark.street ?? ''),
            ),
          );
          addressController.text = placemark.street ?? '';
        });
      }
    } else {
      /*
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zona Segura'),
        ),
        body: const Center(
          child: Text('Error al configurar dirección:'),
        ),
      );*/
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al configurar dirección'),
        ),
      );
    }
  }

  void _updateGeofenceCircle(Geocerca geocerca) {
    if (mapController != null) {
      if (markers.isNotEmpty) {
        LatLng markerPosition = markers.first.position;
        double radius = double.tryParse(radiusController.text) ?? 0;
        if (radius > 0) {
          setState(() {
            geocerca = Geocerca(
              idGeocerca: geocercaId,
              radioGeocerca: radius, 
              fecha: DateTime.now(), 
              latitude: markerPosition.latitude, 
              longitude: markerPosition.longitude
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
        }
      }
    } else {
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zona Segura'),
        ),
        body: const Center(
          child: Text('Error al configurar y actualizar zona segura:'),
        ),
      );

    }
  }
  void _createGeofenceCircle(String? dispositivoPacienteId) {
    if (mapController != null) {
      if (markers.isNotEmpty) {
        LatLng markerPosition = markers.first.position;
        double radius = double.tryParse(radiusController.text) ?? 0;
        if (radius > 0) {
          final nuevaGeocerca = Geocerca(
            radioGeocerca: radius, 
            fecha: DateTime.now(), 
            latitude: markerPosition.latitude, 
            longitude: markerPosition.longitude
          );
          geocercaService.crearGeocerca(nuevaGeocerca);
          setState(() {
            dispositivo = Dispositivos(
              idDispositivo: dispositivoPacienteId,
              idGeocerca: nuevaGeocerca.idGeocerca!,
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
        }
      }
    } else {
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zona Segura'),
        ),
        body: const Center(
          child: Text('Error al obtener el usuario:'),
        ),
      );

    }
  }

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
          title: const Text('Zona Segura'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Zona Segura'),
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
                title: const Text('Zona Segura'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (usuarioSnapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Zona Segura'),
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

  Widget _buildLocationWidget(BuildContext context, Usuarios usuario) {
    if (geofenceCenter == null) {
      return const CircularProgressIndicator();
    }
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
          print(paciente);
          dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
          //validar si existe geocerca: crear || actualizar
          geocercaId = paciente.idDispositivo.idGeocerca?.idGeocerca;
          if(geocercaId != null){ 
            //geocerca nula
            return FutureBuilder<Geocerca>(
              future: geocercaService.obtenerGeocerca(geocercaId!),
              builder: (context, geocercaSnapshot){
                if(geocercaSnapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if(geocercaSnapshot.hasError){
                  return Center(
                    child: Text('Error al obtener la zona segura: ${geocercaSnapshot.error}'),
                  );
                } else {
                  final geocerca = geocercaSnapshot.data!;
                  double radius = geocerca.radioGeocerca ?? 0;
                  if (radius > 0) {
                    geofenceCircle = Circle(
                      circleId: const CircleId('geofence_circle'),
                      center: LatLng(geocerca.latitude, geocerca.longitude),
                      radius: radius,
                      fillColor: Colors.blue.withOpacity(0.3),
                      strokeWidth: 2,
                      strokeColor: Colors.blue,
                    );
                  }
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      title: const Text('Zona Segura'),
                    ),
                    body: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(geocerca.latitude, geocerca.longitude),
                            zoom: 20,
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
                                  final geocerca = geocercaSnapshot.data!;
                                  _updateGeofenceCircle(geocerca);
                                },
                                child: const Text('Establecer geocerca'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            );
          } else {
            return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Zona Segura'),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: geofenceCenter,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  onTap: _onMapTap,
                  markers: markers,
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
                          _createGeofenceCircle(dispositivoPacienteId);
                        },
                        child: const Text('Establecer geocerca'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }
    },
  );
}
}
            //geocerca es nulo - no existe -> crear
            /*
            double radius = double.tryParse(radiusController.text) ?? 0;
            LatLng markerPosition = markers.first.position;
            if (radius > 0) {
              geofenceCircle = Circle(
                circleId: const CircleId('geofence_circle'),
                center: markerPosition,
                radius: radius,
                fillColor: Colors.blue.withOpacity(0.3),
                strokeWidth: 2,
                strokeColor: Colors.blue,
              );
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Zona Segura'),
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialCameraPosition,
                      zoom: 15,
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
                            _createGeofenceCircle();
                          },
                          child: const Text('Establecer geocerca'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}*/

