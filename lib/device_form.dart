/*import 'package:alzheimer_app1/device_mgmt.dart';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/patient_selection.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

final deviceService = DispositivosService();

class DeviceForm extends StatefulWidget {
  const DeviceForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final roundedDecoration = InputDecoration(
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
        title: const Text('Registro Dispositivo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DeviceMmgt()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'IdDispositivo'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 17) {
                    print("************ value Dispositivo **************");
                    print(value);
                    return 'Ingrese un IdDispositivo válido (17 caracteres con formato 00:00:00:00:00)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    //obtener valores de formulario
                    final formValues = _fbKey.currentState!.value;
                    //Creacion de objeto persona con valores de formulario
                    print("************ ID Dispositivo **************");
                    print(formValues['IdDispositivo']);
                    final nuevoDispositivo = Dispositivos(
                      idDispositivo: formValues['IdDispositivo'],
                    );
                    try{
                      dispositivoService.crearDispositivo(nuevoDispositivo);
                      if(!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dispositivo registrado con éxito')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al registrar dispositivo : $e')),
                      );
                    }
                  } 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeviceMmgt(),
                    ),
                  );
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
*/


import 'package:alzheimer_app1/device_mgmt.dart';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

final deviceService = DispositivosService();

class DeviceForm extends StatefulWidget {
  const DeviceForm({super.key});

  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final roundedDecoration = InputDecoration(
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
        title: const Text('Registro Dispositivo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DeviceMmgt()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'IdDispositivo',
                decoration: const InputDecoration(labelText: 'IdDispositivo'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 17) {
                    print("************ value Dispositivo **************");
                    print(value);
                    return 'Ingrese un IdDispositivo válido (17 caracteres con formato 00:00:00:00:00)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    // Obtener valores de formulario
                    final formValues = _fbKey.currentState!.value;
                    // Creación de objeto dispositivo con valores de formulario
                    print("************ ID Dispositivo **************");
                    print(formValues['IdDispositivo']);
                    final nuevoDispositivo = Dispositivos(
                      idDispositivo: formValues['IdDispositivo'],
                    );
                    try {
                      await deviceService.crearDispositivo(nuevoDispositivo);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dispositivo registrado con éxito')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al registrar dispositivo: $e')),
                      );
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeviceMmgt(),
                    ),
                  );
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
