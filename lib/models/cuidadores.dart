import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/models/familiares.dart';

class Cuidadores{
  final String? idCuidador;
  final Usuarios idUsuario;
  final Familiares idFamiliar;
  final PacientesCuidadores? pacientesCuidadores;
  
  
  Cuidadores({
    this.idCuidador,
    required this.idUsuario,
    required this.idFamiliar,
    this.pacientesCuidadores,
  });

  factory Cuidadores.fromJson(Map<String, dynamic> json){
    return Cuidadores(
      idCuidador: json['IdCuidador']as String?,
      idUsuario: Usuarios.fromJson(json['IdUsuarioNavigation']),
      idFamiliar: Familiares.fromJson(json['IdFamiliarNavigation']),
      pacientesCuidadores: json['PacientesCuidadores'] != null ? PacientesCuidadores.fromJson(json['PacientesCuidadores']) : null,
    );
  }

  /*Map<String, dynamic> toJson(){
    return{
      'IdCuidador': idCuidador?? '',
      'IdUsuario': idUsuario.idUsuario,
      'IdFamiliar': idFamiliar.idFamiliar,
      'PacientesCuidadores': pacientesCuidadores!.idCuidaPaciente,
    };
  }*/
  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = {
    'IdCuidador': idCuidador ?? '',
    'IdUsuario': idUsuario.idUsuario,
    'IdFamiliar': idFamiliar.idFamiliar,
  };

  if (pacientesCuidadores != null) {
    data['PacientesCuidadores'] = pacientesCuidadores!.toJson();
  }

  return data;
}
}