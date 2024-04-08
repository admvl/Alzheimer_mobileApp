import 'package:flutter/material.dart';

class FallAlarmScr extends StatefulWidget {
  const FallAlarmScr({super.key});

  @override
  State<FallAlarmScr> createState() => _FallAlarmScrState();
}

class _FallAlarmScrState extends State<FallAlarmScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/previews/017/172/377/original/warning-message-concept-represented-by-exclamation-mark-icon-exclamation-symbol-in-triangle-png.png",
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Caída registrada",
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
              child: const Text("Consultar Ubicación Actual"),
            ),
          ],
        ),
      ),
    );
  }
}
