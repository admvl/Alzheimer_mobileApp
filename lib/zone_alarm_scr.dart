import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ZoneAlarmScr extends StatefulWidget {
  final String? nombrepaciente;
  const ZoneAlarmScr({super.key, this.nombrepaciente});

  @override
  State<ZoneAlarmScr> createState() => _ZoneAlarmScrState();
}

class _ZoneAlarmScrState extends State<ZoneAlarmScr> {
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/previews/009/266/387/non_2x/exclamation-mark-icon-free-png.png",
                    width: 150, height: 150
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "¡Advertencia!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "El paciente ${widget.nombrepaciente} ha rebasado la zona segura rebasada",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Aceptar"),
            ),
          ],
        ),
      ),
    );
  }
}
