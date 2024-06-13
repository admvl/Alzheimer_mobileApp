import 'package:alzheimer_app1/models/notificaciones.dart';
import 'package:alzheimer_app1/services/notificaciones_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/medicamentos_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/pacientes.dart';
import 'models/medicamentos.dart';

final PacientesService _pacientesService = PacientesService();
final MedicamentosService _medicamentosService = MedicamentosService();
final NotificacionesService _notificacionesService = NotificacionesService();
final tokenUtils = TokenUtils();

class SetAlarmScr extends StatefulWidget {
  const SetAlarmScr({super.key});

  @override
  State<SetAlarmScr> createState() => _SetAlarmScrState();
}

class _SetAlarmScrState extends State<SetAlarmScr> {
  TimeOfDay _hora = TimeOfDay.now();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<Medicamentos> medicamentos = [];
  Medicamentos? medicamentoSeleccionado;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige al paciente:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _pacientesService.obtenerPacientesPorId(idUsuario!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  final List<Pacientes> pacientes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return ListTile(
                        title: Text(
                          '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}',
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _buildAlarm(context, paciente),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(paciente.idPersona.nombre),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void alarmCallback() {
    print("La alarma se ha activado!");
  }

  void _scheduleAlarm(Pacientes paciente, TimeOfDay sethora) async {
    final notificacion = Notificaciones(
      mensaje: 'Medicamento de ${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}',
      fecha: null,
      hora: sethora,
      idPaciente: paciente.idPaciente!,
      idTipoNotificacion: 'E7C6F965-66D1-48C5-B38A-3B5EBC1966B1',
      enviada: false,
    );
    try {
      await _notificacionesService.crearNotificacion(notificacion);
    } catch (e) {
      throw Exception("Error al crear alarma $e");
    }
    // Programar la alarma usando Android Alarm Manager
  }

  Widget _buildAlarm(BuildContext context, Pacientes paciente) {
    return FutureBuilder<List<Medicamentos>>(
      future: _medicamentosService.obtenerMedicamentosPorId(paciente.idPaciente!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Nueva Alarma'),
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
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          medicamentos = snapshot.data!;
          if (medicamentos.isNotEmpty) {
            medicamentoSeleccionado = medicamentos.first;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Nueva Alarma'),
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Hora de la alarma
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? nuevaHora = await showTimePicker(
                                context: context,
                                initialTime: _hora,
                              );
                              if(nuevaHora != null ){
                                print(nuevaHora);
                                _hora = nuevaHora;
                              }
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(color: Colors.teal.shade900),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _hora.format(context),
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Lista de medicamentos
                    const SizedBox(height: 20.0),
                    const Text('Medicamento:'),
                    const SizedBox(height: 2.0),
                    if (medicamentos.isNotEmpty)
                      DropdownButton<Medicamentos>(
                        value: medicamentoSeleccionado,
                        items: medicamentos.map((medicamento) => DropdownMenuItem(
                          value: medicamento,
                          child: Text(medicamento.nombre),
                        )).toList(),
                        onChanged: (value) {
                          if (!mounted) return;  // Check if the widget is still mounted
                          setState(() {
                            medicamentoSeleccionado = value!;
                          });
                        },
                      )
                    else
                      const Text('No hay medicamentos disponibles'),

                    const SizedBox(height: 16.0),

                    // Botón para crear la alarma
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Crear la alarma
                        print('Alarma creada!');
                        _scheduleAlarm(paciente, _hora);
                        Navigator.pop(context);
                      },
                      child: const Text('Crear Alarma'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
