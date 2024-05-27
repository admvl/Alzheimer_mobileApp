import 'package:alzheimer_app1/models/usuarios.dart';
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
      idCuidador: json['IdCuidador']as String?,
      idUsuario: Usuarios.fromJson(json['IdUsuarioNavigation']),
      idFamiliar: Familiares.fromJson(json['IdFamiliarNavigation']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdCuidador': idCuidador?? '',
      'IdUsuario': idUsuario.idUsuario,
      'IdFamiliar': idFamiliar.idFamiliar,
    };
  }
}