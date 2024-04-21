import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/tipos_usuarios.dart';

class Usuarios {
  final String? idUsuario;
  final String correo;
  final String contrasenia;
  final bool? estado;
  final TiposUsuarios? idTipoUsuario;
  final Personas? idPersona;

  Usuarios({
    this.idUsuario,
    required this.correo,
    required this.contrasenia,
    this.estado,
    this.idTipoUsuario,
    this.idPersona,
  });

  // Método para crear una instancia de Personas a partir de un JSON
  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      idUsuario: json['IdUsuario'] as String,
      correo: json['Correo'] as String,
      contrasenia: json['Contrasenia'] as String,
      estado: json['Estado'] as bool,
      idTipoUsuario: TiposUsuarios.fromJson(json['IdTipoUsuario']),
      idPersona: Personas.fromJson(json['IdPersona']),
    );
  }

  // Método para convertir la instancia de Personas a JSON
  Map<String, dynamic> toJson() {
    return {
      'Correo': correo,
      'Contrasenia': contrasenia,
      'Estado': estado,
      'IdTipoUsuario': idTipoUsuario?.idTipoUsuario,
      'IdPersona': idPersona?.toJson(),
    };
  }
}
