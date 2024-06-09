import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/models/familiares.dart';

class Cuidadores{
  final String? idCuidador;
  final Usuarios idUsuario;
  final Familiares? idFamiliar;
  final List<PacientesCuidadores?>? pacientesCuidadores;
  
  
  Cuidadores({
    this.idCuidador,
    required this.idUsuario,
    this.idFamiliar,
    this.pacientesCuidadores,
  });

  factory Cuidadores.fromJson(Map<String, dynamic> json){
    return Cuidadores(
      idCuidador: json['IdCuidador']as String?,
      idUsuario: Usuarios.fromJson(json['IdUsuarioNavigation']),
      idFamiliar: json['IdFamiliarNavigation']!= null ? Familiares.fromJson(json['IdFamiliarNavigation']) : null,
      pacientesCuidadores: json['PacientesCuidadores'] != null ?
        (json['PacientesCuidadores'] as List).map((i)=> PacientesCuidadores.fromJson(i))
        .toList() : null,
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
    'IdFamiliar': idFamiliar?.idFamiliar,
  };

  if (pacientesCuidadores != null) {
    data['PacientesCuidadores'] = pacientesCuidadores!.map((i) => i!.toJson()).toList();
  }

  return data;
}
}