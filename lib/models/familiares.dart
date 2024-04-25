
import 'package:alzheimer_app1/models/usuarios.dart';

class Familiares{
  final String? idFamiliar;
  final Usuarios idUsuario;
  
  
  Familiares({
    this.idFamiliar,
    required this.idUsuario,
  });

  factory Familiares.fromJson(Map<String, dynamic> json){
    return Familiares(
      idFamiliar: json['IdFamiliar']as String,
      idUsuario: Usuarios.fromJson(json['IdUsuarioNavigation']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdFamiliar': idFamiliar ?? '',
      'IdUsuario': idUsuario.idUsuario,
    };
  }
}