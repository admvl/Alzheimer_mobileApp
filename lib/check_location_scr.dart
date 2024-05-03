
import 'package:alzheimer_app1/carer_form.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/ubicaciones.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/services/ubicaciones_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';

import 'welcome_scr.dart';

final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final dispositivosService = DispositivosService();
final ubicacionesService = UbicacionesService();
final tokenUtils = TokenUtils();

class CheckLocationScr extends StatefulWidget {
  const CheckLocationScr({super.key});

  @override
  _CheckLocationScrState createState() => _CheckLocationScrState();
}

class _CheckLocationScrState extends State<CheckLocationScr> {
  String? dispositivoPacienteId;
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
          title: const Text('Ubicación del paciente'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: Center(
          child: Text('Error al obtener el token: ${snapshot.error}'),
        ),
      );
    } else {
      final usuario = usuarioSnapshot.data!;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Ubicación del paciente'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate to the Welcome Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Paciente: ${usuario.nombre}',
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Display Ubicacion data
                  FutureBuilder<Widget>(
                    future: _buildUserLocation(context, usuario),
                    builder: (context, widgetSnapshot) {
                      if (widgetSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (widgetSnapshot.hasError) {
                        return Text('Error: ${widgetSnapshot.error}');
                      } else {
                        return widgetSnapshot.data!;
                      }
                    },
                  ),
                ],
              ),
            ),
          );
      /*
      return FutureBuilder<Usuarios>(
        future: usuariosService.obtenerUsuarioPorId(snapshot.data!),
        builder: (context, usuarioSnapshot) {
          if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (usuarioSnapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Ubicación del paciente'),
              ),
              body: Center(
                child: Text('Error al obtener el usuario: ${usuarioSnapshot.error}'),
              ),
            );
          } else {
            final usuario = usuarioSnapshot.data!;
            //final paciente = pacientesService.obtenerPacientePorId(usuario.idUsuario!);
            //final dispositivo = dispositivosService.obtenerDispositivoPorId(paciente.idPaciente!);
            //final paciente = pacienteSnapshot.data!;
            //dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;
            return _buildUserLocation(context, usuario);
          }
        },
      );*/
    }
  }

  Future<Widget> _buildUserLocation(BuildContext context, Usuarios usuario) async {
    // Fetch Pacientes data using usuario.idUsuario
    final pacienteResponse = await pacientesService.obtenerPacientePorId(usuario.idUsuario!);

    // Check for errors in the response
    if (pacienteResponse == null) {
      // Handle error: Paciente not found
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: const Center(
          child: Text('Error al obtener el paciente'),
        ),
      );
    }

    final paciente = pacienteResponse; // Assuming successful response

    // Extract device ID from Pacientes
    final dispositivoPacienteId = paciente.idDispositivo.idDispositivo!;

    // Fetch Personas data using paciente.idPersona
    final personaResponse = await personasService.obtenerPersonaPorId(paciente.idPersona!.idPersona!);

    // Check for errors in the response
    if (personaResponse == null) {
      // Handle error: Persona not found
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ubicación del paciente'),
        ),
        body: const Center(
          child: Text('Error al obtener la información personal'),
        ),
      );
    }

    final persona = personaResponse; // Assuming successful response

    // Fetch Ubicacion data using dispositivoPacienteId
    final ubicacion = await ubicacionesService.obtenerUbicacion(dispositivoPacienteId);

    // Display the user's location and information
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ubicación del paciente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the Welcome Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Paciente: ${persona.nombre}',
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ... (Display Ubicacion data)
          ],
        ),
      ),
    );
  }
}