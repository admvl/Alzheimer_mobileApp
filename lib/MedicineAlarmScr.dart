import 'package:flutter/material.dart';

class MedicineAlarmScr extends StatefulWidget {
  const MedicineAlarmScr({super.key});

  @override
  State<MedicineAlarmScr> createState() => _MedicineAlarmScrState();
}

class _MedicineAlarmScrState extends State<MedicineAlarmScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/previews/018/931/118/original/alarm-clock-icon-png.png",
                    width: 150, height: 150
                  ),
                ),
              ],
            ),
            const Text(
              "¡Alarma!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Es hora de tomar tu medicamento.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
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
