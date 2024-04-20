import 'package:flutter/material.dart';

class ZoneAlarmScr extends StatefulWidget {
  const ZoneAlarmScr({super.key});

  @override
  State<ZoneAlarmScr> createState() => _ZoneAlarmScrState();
}

class _ZoneAlarmScrState extends State<ZoneAlarmScr> {
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
            const Text(
              "Zona segura rebasada",
              style: TextStyle(
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
