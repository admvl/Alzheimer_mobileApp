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
      idTipoUsuario: TiposUsuarios.fromJson(json['IdTipoUsuarioNavigation']),
      idPersona: Personas.fromJson(json['IdPersonaNavigation']),
    );
  }

  // Método para convertir la instancia de Personas a JSON  
  Map<String, dynamic> toJson() {
    return {
      if(idUsuario!=null) 'IdUsuario': idUsuario,
      //'IdUsuario': idUsuario ?? '',
      'Correo': correo,
      'Contrasenia': contrasenia,
      'Estado': estado,
      'IdTipoUsuario': idTipoUsuario?.idTipoUsuario,
      if(idPersona?.idPersona!=null)'IdPersona': idPersona?.idPersona,
      //'IdPersona': idPersona?.idPersona?? '',
    };
  }
}
