import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CheckGeocerca extends StatelessWidget {
  const CheckGeocerca({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Geofence Example',
      home: CheckGeocercaScr(),
    );
  }
}

class CheckGeocercaScr extends StatefulWidget {
  const CheckGeocercaScr({super.key});

  @override
  _CheckGeocercaScrState createState() => _CheckGeocercaScrState();
}

class _CheckGeocercaScrState extends State<CheckGeocercaScr> {
  late GoogleMapController mapController;
  LatLng initialCameraPosition = const LatLng(0, 0);
  TextEditingController addressController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  Set<Marker> markers = {};
  Circle? geofenceCircle;
  late LatLng geofenceCenter;

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
        mapController.animateCamera(CameraUpdate.newLatLngZoom(geofenceCenter, 15.0));
      });
    }
  }

  void _onMapTap(LatLng position) async {
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
  }

  void _updateGeofenceCircle() {
    if (markers.isNotEmpty) {
      LatLng markerPosition = markers.first.position;
      double radius = double.tryParse(radiusController.text) ?? 0;
      if (radius > 0) {
        setState(() {
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
  }

  void saveDataGeocerca(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence Example'),
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
            circles: geofenceCircle != null ? Set.of([geofenceCircle!]) : Set(),
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
                    _updateGeofenceCircle();

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
