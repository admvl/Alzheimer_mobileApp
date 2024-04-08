//dart
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

}
