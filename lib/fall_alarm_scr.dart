import 'package:alzheimer_app1/check_location_scr.dart';
import 'package:flutter/material.dart';

class FallAlarmScr extends StatefulWidget {
  final String? nombrepaciente;
  const FallAlarmScr({super.key,this.nombrepaciente});

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
            Text(
              "El paciente ${widget.nombrepaciente} Caída registrada",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>
                const CheckLocationScr()));
              },
              child: const Text("Consultar Ubicación Actual"),
            ),
          ],
        ),
      ),
    );
  }
}
