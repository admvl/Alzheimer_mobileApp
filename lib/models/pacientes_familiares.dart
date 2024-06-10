import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';

class PacientesFamiliares{
  final String? idPacienteFamiliar;
  final String idPaciente;
  final String idFamiliar;
  
  
  PacientesFamiliares({
    this.idPacienteFamiliar,
    required this.idPaciente,
    required this.idFamiliar,
  });

  factory PacientesFamiliares.fromJson(Map<String, dynamic> json){
    return PacientesFamiliares(
      idPacienteFamiliar: json['IdPacienteFamiliar']as String,
      idPaciente: json['IdPaciente'] as String,
      idFamiliar: json['IdFamiliar'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(idPacienteFamiliar!=null) 'IdPacienteFamiliar': idPacienteFamiliar,
      'IdPaciente': idPaciente,
      'IdFamiliar': idFamiliar,
    };
  }
}