//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
              FormBuilderTextField(
                name: 'fechaNac',
                decoration: _roundedDecoration.copyWith(
                    labelText: 'Fecha de Nacimiento'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.dateString(),
                ]),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    print(_fbKey.currentState!.value);
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
}
