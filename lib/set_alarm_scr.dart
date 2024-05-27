//dart
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

class SetAlarmScr extends StatefulWidget {
  const SetAlarmScr({super.key});

  @override
  State<SetAlarmScr> createState() => _SetAlarmScrState();
}

class _SetAlarmScrState extends State<SetAlarmScr> {
  TimeOfDay _hora = TimeOfDay.now();
  
  // Lista de días para la alarma
  List<String> dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  List<bool> diasSeleccionados = List.filled(7, false);

  // Lista de sonidos para la alarma
  List<String> sonidos = ['Sonido 1', 'Sonido 2', 'Sonido 3', 'Sonido 4'];
  String sonidoSeleccionado = 'Sonido 1';

  // Lista de duraciones para la alarma
  List<String> duraciones = ['1 minuto', '5 minutos', '10 minutos', '15 minutos', '20 minutos', '30 minutos'];
  String duracionSeleccionada = '10 minutos';

  // Lista de medicamentos para la alarma
  List<String> medicamentos = ['medicamentoA', 'medicamentoB', 'medicamentoC', 'medicamentoD', 'medicamentoE', 'medicamentoF'];
  String medicamentosSeleccionados = 'medicamentoA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nueva Alarma'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
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
                        if (nuevaHora != null) {
                          setState(() {
                            _hora = nuevaHora;
                          });
                        }
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100.0), // Set desired width
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

              //lista medicamentos
              const SizedBox(height: 20.0),
              const Text('Medicamento:'),
              const SizedBox(height: 2.0),
              DropdownButton<String>(
                value: medicamentosSeleccionados,
                items: medicamentos.map((medicamento) => DropdownMenuItem(
                  value: medicamento,
                  child: Text(medicamento),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    medicamentosSeleccionados = value!;
                  });
                },
              ),

              // Días de la semana
              const SizedBox(height: 16.0),
              const Text('Días de la semana:'),
              const SizedBox(height: 2.0),
              ElevatedButton(
                onPressed: _mostrarDialogoDias,
                child: const Text('Repetir'),
              ),

              // Sonido de la alarma
              const SizedBox(height: 16.0),
              const Text('Sonido:'),
              const SizedBox(height: 2.0),
              DropdownButton<String>(
                value: sonidoSeleccionado,
                items: sonidos.map((sonido) => DropdownMenuItem(
                  value: sonido,
                  child: Text(sonido),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    sonidoSeleccionado = value!;
                  });
                },
              ),

              // Duración de la alarma
              const SizedBox(height: 16.0),
              const Text('Duración:'),
              const SizedBox(height: 2.0),
              DropdownButton<String>(
                value: duracionSeleccionada,
                items: duraciones.map((duracion) => DropdownMenuItem(
                  value: duracion,
                  child: Text(duracion),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    duracionSeleccionada = value!;
                  });
                },
              ),

              // Botón para crear la alarma
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Crear la alarma
                  print('Alarma creada!');
                  _scheduleAlarm();
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
  
  Future<void> _mostrarDialogoDias() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context,setState) => AlertDialog(
          title: const Text('Seleccionar días'),
          content: SingleChildScrollView(
            child: ListBody(
              children: dias.map((dia) {
                return CheckboxListTile(
                  title: Text(dia),
                  value: diasSeleccionados[dias.indexOf(dia)],
                  onChanged: (value) {
                    setState(() {
                      diasSeleccionados[dias.indexOf(dia)] = value!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
// Esta función debe estar fuera de cualquier clase
  void alarmCallback() {
    print("La alarma se ha activado!");
    // Aquí puedes agregar código para mostrar notificaciones, por ejemplo.
  }
  void _scheduleAlarm() {
    final int nowDayOfWeek = DateTime.now().weekday;  // 1 = Monday, 7 = Sunday
    final DateTime now = DateTime.now();

    // Calcula la próxima fecha de cada día seleccionado
    for (int i = 0; i < diasSeleccionados.length; i++) {
      if (diasSeleccionados[i]) {
        // `i + 1` porque `dias` empieza en Lunes que es `1` en `DateTime.weekday`
        int daysToAdd = (i + 1 - nowDayOfWeek) % 7;
        daysToAdd = daysToAdd <= 0 ? daysToAdd + 7 : daysToAdd;  // Asegurarse de que sea en el futuro
        final nextDay = now.add(Duration(days: daysToAdd));
        final nextAlarmDateTime = DateTime(
          nextDay.year,
          nextDay.month,
          nextDay.day,
          _hora.hour,
          _hora.minute,
        );

        AndroidAlarmManager.oneShotAt(
          nextAlarmDateTime,
          // Usa un ID único para cada alarma basado en el día de la semana
          i,
          alarmCallback,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );
      }
    }
  }


}
