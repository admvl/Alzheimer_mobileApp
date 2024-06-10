import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/dias.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final pacienteCuidadorService = PacientesCuidadoresService();

class DefinePatientCarerData extends StatefulWidget {
  final Cuidadores? cuidador;
  final Pacientes? paciente;

  //const DefinePatientCarerData({super.key});
  const DefinePatientCarerData({super.key, this.paciente, this.cuidador});

  @override
  _DefinePatientCarerDataState createState() => _DefinePatientCarerDataState();
}

class _DefinePatientCarerDataState extends State<DefinePatientCarerData> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;
  final List<String> _selectedDays = [];
  late TextEditingController _idPacienteControllerName;
  late TextEditingController _idPacienteController;
  late TextEditingController _idCuidadorControllerName;
  late TextEditingController _idCuidadorController;

  @override
  void initState() {
    super.initState();
    _idPacienteControllerName = TextEditingController(text: '${widget.paciente!.idPersona.nombre} ${widget.paciente!.idPersona.apellidoP} ${widget.paciente!.idPersona.apellidoM}');
    _idPacienteController = TextEditingController(text: '${widget.paciente!.idPaciente}');
    _idCuidadorControllerName = TextEditingController(text: "${widget.cuidador!.idUsuario.idPersona!.nombre} ${widget.cuidador!.idUsuario.idPersona!.apellidoP} ${widget.cuidador!.idUsuario.idPersona!.apellidoM}");
    _idCuidadorController = TextEditingController(text: '${widget.cuidador!.idCuidador}');
    _horaInicio = null;
    _horaFin = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cuidador del Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idPacienteControllerName,
                decoration: const InputDecoration(labelText: 'Paciente'),
                readOnly: true,
              ),
              TextFormField(
                controller: _idCuidadorControllerName,
                decoration: const InputDecoration(labelText: 'ID Cuidador'),
                readOnly: true,
              ),
              ListTile(
                title: const Text('Hora de Inicio'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _horaInicio = time;
                    });
                  }
                },
                subtitle: _horaInicio != null
                    ? Text('${_horaInicio!.hour}:${_horaInicio!.minute}')
                    : const Text('Selecciona la hora de inicio'),
              ),
              ListTile(
                title: const Text('Hora de Fin'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _horaFin = time;
                    });
                  }
                },
                subtitle: _horaFin != null
                    ? Text('${_horaFin!.hour}:${_horaFin!.minute}')
                    : const Text('Selecciona la hora de fin'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Selecciona los días:'),
              ),
              ...['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
                  .map((day) => CheckboxListTile(
                        title: Text(day),
                        value: _selectedDays.contains(day),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedDays.add(day);
                            } else {
                              _selectedDays.remove(day);
                            }
                          });
                        },
                      )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final nuevoPacienteCuidador = PacientesCuidadores(
                        //idPaciente: _idPacienteController.text,
                        idPaciente: widget.paciente!.idPaciente!,
                        //idCuidador: _idCuidadorController.text,
                        idCuidador: widget.cuidador!.idCuidador!,
                        horaInicio: _horaInicio,
                        horaFin: _horaFin,
                        dias: Dias(
                          //idCuidaPaciente: '',
                          lunes: _selectedDays.contains('Lunes'),
                          martes: _selectedDays.contains('Martes'),
                          miercoles: _selectedDays.contains('Miércoles'),
                          jueves: _selectedDays.contains('Jueves'),
                          viernes: _selectedDays.contains('Viernes'),
                          sabado: _selectedDays.contains('Sábado'),
                          domingo: _selectedDays.contains('Domingo'),
                        ),
                      );
                      // Aquí puedes enviar el objeto pacienteCuidador al servidor o guardarlo donde sea necesario
                      print(nuevoPacienteCuidador.toJson());
                      _confirmPatientCuidador(nuevoPacienteCuidador);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmPatientCuidador(PacientesCuidadores nuevoPacienteCuidador) async{
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar vinculacion'),
        content: const Text('¿Está seguro de que desea vincular este cuidador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (shouldAdd == true) {
      _addPatientCuidador(nuevoPacienteCuidador);
    }
  }
  
  Future<void> _addPatientCuidador(PacientesCuidadores nuevoPacienteCuidador) async {
    try {
      await pacienteCuidadorService.crearPacienteCuidador(nuevoPacienteCuidador);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuidador vinculado con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeopleManagementScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vincular cuidador: $e')),
      );
    }
  }

  @override
  void dispose() {
    _idPacienteController.dispose();
    _idCuidadorController.dispose();
    super.dispose();
  }
}