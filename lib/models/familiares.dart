
import 'package:alzheimer_app1/models/Usuarios.dart';

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
      idUsuario: Usuarios.fromJson(json['IdUsuario']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdFamiliar': idFamiliar ?? '',
      'IdUsuario': idUsuario.toJson(),
    };
  }
}