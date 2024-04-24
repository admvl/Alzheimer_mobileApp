import 'package:alzheimer_app1/models/personas.dart';

import 'package:alzheimer_app1/models/usuarios.dart';

class Users{
  final Personas persona;
  final Usuarios usuario;
  Users({
    required this.persona,
    required this.usuario
  });

  Map<String, dynamic> toJson() {
    return {
      'Usuario': usuario.toJson(),
      'Persona': persona.toJson(),
    };
  }
}