//import 'dart:io';

import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/personas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:file_picker/file_picker.dart';

Future<String> getProjectDirPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final DispositivosService _dispositivosService = DispositivosService();
  final PersonasService _personasService = PersonasService();
  final PacientesService _pacientesService = PacientesService();
  Dispositivos? selectedDispositivo;
  List<Dispositivos> dispositivos = [];
  List<DropdownMenuItem<String>> dispositivosItems = [];

  @override
  Widget build(BuildContext context) {
    final _roundedDecoration = InputDecoration(
      labelText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      fillColor: Colors.blue.withOpacity(0.1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registro Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'curp',
                decoration: _roundedDecoration.copyWith(labelText: 'CURP'),
                //validator: FormBuilderValidators.required(context),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'nombre',
                decoration: _roundedDecoration.copyWith(labelText: 'Nombre'),
                //validator: FormBuilderValidators.required(context),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'apellidoPaterno',
                decoration:
                    _roundedDecoration.copyWith(labelText: 'Apellido Paterno'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'apellidoMaterno',
                decoration:
                    _roundedDecoration.copyWith(labelText: 'Apellido Materno'),
              ),
              const SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'fechaNac',
                inputType: InputType.date,
                format: DateFormat("yyyy-MM-dd"),
                decoration: _roundedDecoration.copyWith(
                  labelText: 'Fecha de Nacimiento',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  //FormBuilderValidators.dateString(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown(
                  name: 'dispositivo',
                  decoration: _roundedDecoration.copyWith(
                    labelText: 'Dispositivo',
                  ),
                items: dispositivos.map((dispositivo) {
                  return DropdownMenuItem(
                    value: dispositivo.idDispositivo, // Suponiendo que el id del dispositivo es un String
                    child: Text(dispositivo.idDispositivo!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    // Busca el dispositivo seleccionado en la lista de dispositivos usando su ID
                    selectedDispositivo = dispositivos.firstWhere((dispositivo) => dispositivo.idDispositivo == value);

                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    final formValues = _fbKey.currentState!.value;
                    try {
                      print(_fbKey.currentState!.value);
                      Personas nuevaPersona = Personas(
                          nombre: formValues['nombre'],
                          apellidoP: formValues['apellidoPaterno'],
                          apellidoM: formValues['apellidoMaterno'],
                          fechaNacimiento: formValues['fechaNac']
                      );
                      nuevaPersona = await _personasService.crearPersona(nuevaPersona);
                      try{
                        Pacientes nuevoPaciente = Pacientes(
                            idPaciente: formValues['curp'],
                            idDispositivo: selectedDispositivo!,
                            idPersona: nuevaPersona
                        );
                        _pacientesService.crearPersona(nuevoPaciente);
                        if(!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Paciente registrado con éxito')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            )
                        );
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al crear al registrar el paciente: $e')
                            )
                        );
                      }
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al crear al registrar los datos del paciente: $e')
                          )
                      );
                    }
                  }
                  /* Validar existencia correo en BD
                  if(await checkIfEmailExists()){
                    // Either invalidate using Form Key
                    _formKey.currentState?.fields['email']?.invalidate('Email already taken');
                    // OR invalidate using Field Key
                    _emailFieldKey.currentState?.invalidate('Email already taken');
                  }*/
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    _dispositivosService.obtenerDispositivos().then((dispositivosObtenidos) {
      setState(() {
        dispositivos = dispositivosObtenidos;
      });
    });
  }
}
