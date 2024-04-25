//import 'dart:io';

import 'package:alzheimer_app1/models/tipos_usuarios.dart';
import 'package:alzheimer_app1/models/users.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:alzheimer_app1/services/personas_service.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:intl/intl.dart';

final PersonasService personasService = PersonasService();
final UsuariosService usuariosService = UsuariosService();
class CarerForm extends StatefulWidget {
  final Usuarios? usuario;
  const CarerForm({Key? key, this.usuario}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CarerFormState createState() => _CarerFormState();
}

class _CarerFormState extends State<CarerForm> {
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
        title: const Text('Registro Cuidador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          initialValue: {
            'nombre':widget.usuario?.idPersona?.nombre,
            'apellidoPaterno':widget.usuario?.idPersona?.apellidoP,
            'apellidoMaterno':widget.usuario?.idPersona?.apellidoM,
            'telefono':widget.usuario?.idPersona?.numeroTelefono,
            'correo':widget.usuario?.correo,
            'contraseña':widget.usuario?.contrasenia,
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'nombre',
                decoration: roundedDecoration.copyWith(labelText: 'Nombre'),
                //validator: FormBuilderValidators.required(context),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'apellidoPaterno',
                decoration:
                    roundedDecoration.copyWith(labelText: 'Apellido Paterno'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'apellidoMaterno',
                decoration:
                    roundedDecoration.copyWith(labelText: 'Apellido Materno'),
              ),
              const SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'fechaNac',
                inputType: InputType.date,
                initialDate: widget.usuario?.idPersona?.fechaNacimiento ?? DateTime.now() ,
                format: DateFormat("yyyy-MM-dd"),
                decoration: roundedDecoration.copyWith(
                    labelText: 'Fecha de Nacimiento',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  //FormBuilderValidators.dateString(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'telefono',
                decoration:
                    roundedDecoration.copyWith(labelText: 'Número Telefónico'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'correo',
                decoration: roundedDecoration.copyWith(labelText: 'Correo'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'contraseña',
                decoration:
                    roundedDecoration.copyWith(labelText: 'Contraseña'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                  /*FormBuilderValidators.match( // Validate for at least one uppercase and lowercase letter
                    RegExp(r'[a-z]'), // Matches lowercase letters
                    errorText: 'Debe contener al menos una minúscula'
                  ),
                  FormBuilderValidators.match( // Validate for at least one uppercase letter
                    context,
                    RegExp(r'[A-Z]'), // Matches uppercase letters
                    errorText: 'Debe contener al menos una mayúscula'
                  ),*/
                  //FormBuilderValidators.compose(context, r'(?=.*?[A-Z])', errorText: 'Debe contener al menos una mayúscula'),
                  /*FormBuilderValidators.compose(
                    (val) => val?.contains(RegExp(r'[A-Z]')) ?? false,
                    errorText: 'Debe contener al menos una mayúscula'
                  )
                  
                  FormBuilderValidators.pattern(context, r'(?=.*?[a-z])', errorText: 'Debe contener al menos una minúscula'),
                  FormBuilderValidators.pattern(context, r'(?=.*?[0-9])', errorText: 'Debe contener al menos un dígito'),
                  FormBuilderValidators.pattern(context, r'(?=.*?[!@#$%^&*(),.?":{}|<>])', errorText: 'Debe contener al menos un caracter especial'),
                  */
                ]),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    // Obtener los valores del formulario
                    final formValues = _fbKey.currentState!.value;

                    if(widget.usuario == null) {
                      // Crear un objeto Personas con los valores del formulario
                      final nuevaPersona = Personas(
                        nombre: formValues['nombre'],
                        apellidoP: formValues['apellidoPaterno'],
                        apellidoM: formValues['apellidoMaterno'],
                        fechaNacimiento: formValues['fechaNac'],
                        numeroTelefono: formValues['telefono'],
                      );
                      try {
                        TiposUsuarios tiposUsuarios = await usuariosService.obtenerTipoUsuario('Cuidador');
                        final nuevoUsuario = Usuarios(
                            correo: formValues['correo'],
                            contrasenia: formValues['contraseña'],
                            estado: true,
                            idTipoUsuario: tiposUsuarios,
                            idPersona: nuevaPersona
                        );
                        final nuevoUser = Users(
                            persona:nuevaPersona,
                            usuario:nuevoUsuario
                        );
                        // Enviar la nueva persona al backend usando PersonasService
                        try {
                          await usuariosService.crearUsuario(nuevoUser);
                          if(!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuario registrado con éxito')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al registrar usuario: $e')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al obtener el tipo de usuario: $e')),
                        );
                      }
                    } else{
                      // Crear un objeto Personas con los valores del formulario
                      final nuevaPersona = Personas(
                        idPersona: widget.usuario?.idPersona?.idPersona,
                        nombre: formValues['nombre'],
                        apellidoP: formValues['apellidoPaterno'],
                        apellidoM: formValues['apellidoMaterno'],
                        fechaNacimiento: formValues['fechaNac'],
                        numeroTelefono: formValues['telefono'],
                      );
                      try {
                        TiposUsuarios tiposUsuarios = await usuariosService.obtenerTipoUsuario(widget.usuario!.idTipoUsuario!.tipoUsuario);
                        final nuevoUsuario = Usuarios(
                            idUsuario: widget.usuario?.idUsuario,
                            correo: formValues['correo'],
                            contrasenia: formValues['contraseña'],
                            estado: true,
                            idTipoUsuario: tiposUsuarios,
                            idPersona: nuevaPersona
                        );
                        final nuevoUser = Users(
                            persona:nuevaPersona,
                            usuario:nuevoUsuario
                        );
                        // Enviar la nueva persona al backend usando PersonasService
                        try {
                          await usuariosService.actualizarUsuario(nuevoUser);
                          if(!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuario registrado con éxito')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al registrar usuario: $e')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al obtener el tipo de usuario: $e')),
                        );
                      }

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
                child: Text(widget.usuario == null ? 'Registrar':'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
