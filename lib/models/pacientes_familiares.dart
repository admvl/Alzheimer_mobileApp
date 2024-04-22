import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';

class PacientesFamiliares{
  final String? idPacienteFamiliar;
  final Pacientes idPaciente;
  final Familiares idFamiliar;
  
  
  PacientesFamiliares({
    this.idPacienteFamiliar,
    required this.idPaciente,
    required this.idFamiliar,
  });

  factory PacientesFamiliares.fromJson(Map<String, dynamic> json){
    return PacientesFamiliares(
      idPacienteFamiliar: json['IdPacienteFamiliar']as String,
      idPaciente: Pacientes.fromJson(json['IdPaciente']),
      idFamiliar: Familiares.fromJson(json['IdFamiliar']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdPacienteFamiliar': idPacienteFamiliar ?? '',
      'IdPaciente': idPaciente.idPaciente,
      'IdFamiliar': idFamiliar.idFamiliar,
    };
  }
}