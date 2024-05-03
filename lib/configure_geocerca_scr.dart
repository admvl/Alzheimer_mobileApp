import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckGeocercaScr extends StatefulWidget {
  const CheckGeocercaScr({super.key});

  @override
  State<CheckGeocercaScr> createState() => _CheckGeocercaScrState();
}

class _CheckGeocercaScrState extends State<CheckGeocercaScr> {
  LatLng? selectedLocation;

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(19.504711, -99.144362),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configuración de Zona Segura'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Ajusta la ubicación de la zona segura:',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 500,
              height: 300,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    onTap: (LatLng tapPosition) {
                      setState(() {
                        selectedLocation = tapPosition;
                      });
                    },
                  ),
                  /*
                  if (selectedLocation != null)
                    Circle(
                      center: selectedLocation!,
                      radius: 100,
                      fillColor: Colors.blue.withOpacity(0.3),
                      strokeColor: Colors.blue,
                      strokeWidth: 2,
                      circleId: const CircleId('circle_id'),
                    )*/
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement logic to store the selected location data
                // (e.g., save to database or shared preferences)
                if (selectedLocation != null) {
                  // Show a confirmation dialog or message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Zona segura configurada'),
                    ),
                  );
                } else {
                  // Show an error message if no location is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes seleccionar una ubicación'),
                    ),
                  );
                }
              },
              child: const Text('Guardar Zona Segura'),
            ),
          ],
        ),
      ),
    );
  }
}
