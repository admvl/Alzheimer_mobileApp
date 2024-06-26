import 'dart:async';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConnectionStatusPage extends StatefulWidget {
  final String? nombrepaciente;
  const ConnectionStatusPage({super.key,this.nombrepaciente});

  @override
  _ConnectionStatusPageState createState() => _ConnectionStatusPageState();
}

class _ConnectionStatusPageState extends State<ConnectionStatusPage> {
  final StreamController<bool> _connectionController = StreamController<bool>();
  Timer? _timer; // Referencia al Timer para poder cancelarlo
  bool _isConnected = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Simular cambios en la conexión cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _isConnected = !_isConnected; // Cambia el estado de conexión
      if (!_connectionController.isClosed) {
        _connectionController.add(_isConnected); // Envía el nuevo estado al Stream solo si el controller no está cerrado
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el Timer
    _connectionController.close(); // Cierra el StreamController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Conexión del Dispositivo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pop(context);
            /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );*/
          },
        ),
      ),
      body: StreamBuilder<bool>(
        stream: _connectionController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData || snapshot.data == false) {
              // Si se pierde la conexión
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.signal_wifi_off, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Se ha perdido la conexión \ncon el paciente \n${widget.nombrepaciente}',
                        style: const TextStyle(fontSize: 24)
                        ),
                  ],
                ),
              );
            }
            else {
              // Si hay conexión
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.signal_wifi_4_bar, size: 80, color: Colors.green),
                    SizedBox(height: 20),
                    Text('Conectado', style: TextStyle(fontSize: 24)),
                  ],
                ),
              );
            }
          } else {
            // Cuando el Stream está esperando datos iniciales
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
