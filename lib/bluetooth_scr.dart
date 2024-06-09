import 'dart:convert';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScr extends StatefulWidget {
  const BluetoothScr({super.key});

  @override
  _BluetoothScrState createState() => _BluetoothScrState();
}

class _BluetoothScrState extends State<BluetoothScr> {
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  List<BluetoothDevice> pairedDevices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    // Request permissions for Bluetooth and location
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allPermissionsGranted = statuses[Permission.bluetooth]?.isGranted ?? false;

    if (allPermissionsGranted) {
      listPairedDevices();
    } else {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permisos no concedidos. No se puede continuar")),
      );
      //print("Permissions not granted. Unable to proceed.");
    }
  }

  void listPairedDevices() async {
    setState(() {
      isScanning = true;
    });

    // Getting the list of connected devices
    pairedDevices = FlutterBluePlus.connectedDevices;

    // Getting the list of paired devices
    pairedDevices += await FlutterBluePlus.bondedDevices;

    setState(() {
      isScanning = false;
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    setState(() {
      targetDevice = device;
    });

    try {
      await targetDevice!.connect();
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Dispositivo conectado")),
      );
      discoverServices();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Dispositivo desconectado")),
      );
    }
  }

  void discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toUpperCase() == "12345678-1234-1234-1234-123456789012") {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toUpperCase() == "12345678-1234-1234-1234-123456789013") {
            setState(() {
              targetCharacteristic = characteristic;
            });
          }
        }
      }
    }
  }

  void writeData(String data) async {
    if (targetCharacteristic == null) return;

    try{
      await targetCharacteristic!.write(utf8.encode(data), withoutResponse: false);
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Datos enviados al dispositivo")),
      );
      //print("Data sent to the device");
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al enviar datos al dispositivo")),
      );
    }
  }

  @override
  void dispose() {
    targetDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController ssidController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bluetooth Connection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: isScanning
            ? const CircularProgressIndicator()
            : pairedDevices.isEmpty
            ? const Text("No paired devices found")
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (targetDevice == null)
              ...[
                const Text("Paired Devices:"),
                Expanded(
                  child: ListView.builder(
                    itemCount: pairedDevices.length,
                    itemBuilder: (context, index) {
                      BluetoothDevice device = pairedDevices[index];
                      return ListTile(
                        title: Text(device.platformName),
                        subtitle: Text(device.remoteId.toString()),
                        onTap: () => connectToDevice(device),
                      );
                    },
                  ),
                ),
              ],
            if (targetDevice != null)
              ...[
                Text("Connected to ${targetDevice!.platformName}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: ssidController,
                    decoration: const InputDecoration(
                      labelText: 'SSID',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String ssid = ssidController.text;
                    String password = passwordController.text;
                    writeData("$ssid:$password");
                  },
                  child: const Text('Conectar al Wi-Fi'),
                )
              ],
          ],
        ),
      ),
    );
  }
}
