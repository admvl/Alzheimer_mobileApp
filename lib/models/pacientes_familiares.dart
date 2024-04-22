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
      idPacienteFamiliar: json['idPacienteFamiliar']as String,
      idPaciente: Pacientes.fromJson(json['idPaciente']),
      idFamiliar: Familiares.fromJson(json['idFamiliar']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'idPacienteFamiliar': idPacienteFamiliar ?? '',
      'idPaciente': idPaciente?.idPaciente,
      'idFamiliar': idFamiliar?.idFamiliar,
    };
  }
}