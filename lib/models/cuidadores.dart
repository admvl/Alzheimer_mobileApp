import 'package:alzheimer_app1/models/Usuarios.dart';
import 'package:alzheimer_app1/models/familiares.dart';

class Cuidadores{
  final String? idCuidador;
  final Usuarios idUsuario;
  final Familiares idFamiliar;
  
  
  Cuidadores({
    this.idCuidador,
    required this.idUsuario,
    required this.idFamiliar,
  });

  factory Cuidadores.fromJson(Map<String, dynamic> json){
    return Cuidadores(
      idCuidador: json['idCuidador']as String,
      idUsuario: Usuarios.fromJson(json['idUsuario']),
      idFamiliar: Familiares.fromJson(json['idFamiliar']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'idCuidador': idCuidador ?? '',
      'idUsuario': idUsuario.toJson(),
      'idFamiliar': idFamiliar.toJson(),
    };
  }
}