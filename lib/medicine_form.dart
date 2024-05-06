//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class MedicineForm extends StatefulWidget {
  const MedicineForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
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
        title: const Text('Registro de Medicamentos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'nombreMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Nombre del Medicamento'),
                //validator: FormBuilderValidators.required(context),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              /*FormBuilderDropdown(
                name: 'tipoMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Tipo de Medicamento'),
                // Add the following properties for the dropdown:
                initialValue: 'Medicamentos por vía oral',  // Set an initial value
                //allowClear: true,          // Allow clearing the selection
                items: const [
                  DropdownMenuItem(
                    value: 'medOral', 
                    child: Text(
                      'Medicamentos por vía oral',
                      style: TextStyle(color: Color.fromARGB(255, 83, 80, 80)),
                    )
                  ),
                  DropdownMenuItem(value: 'medInyectable', 
                   child: Text(
                      'Medicamentos inyectable',
                      style: TextStyle(color: Color.fromARGB(255, 83, 80, 80)),
                    )
                  ),
                  DropdownMenuItem(value: 'medTopico', 
                   child: Text(
                      'Medicamentos de uso tópico',
                      style: TextStyle(color: Color.fromARGB(255, 83, 80, 80)),
                    )
                  ),
                  DropdownMenuItem(value: 'otrosMed',
                   child: Text(
                      'Otros',
                      style: TextStyle(color: Color.fromARGB(255, 83, 80, 80)),
                    )
                  ),
                ],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),*/
              FormBuilderTextField(
                name: 'gramajeMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Gramaje del Medicamento'),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'dosisMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Dósis del Medicamento por toma'),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'notasMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Notas'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    print(_fbKey.currentState!.value);
                    try{

                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error al registrar el medicamento: $e')),
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
}
