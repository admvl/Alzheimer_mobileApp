import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes.dart';

class PacientesCuidadores{
  final String? idCuidaPaciente;
  final Pacientes idPaciente;
  final Cuidadores idCuidador;
  final DateTime horaInicio;
  final DateTime horaFin;
  
  
  PacientesCuidadores({
    this.idCuidaPaciente,
    required this.idPaciente,
    required this.idCuidador,
    required this.horaInicio,
    required this.horaFin,
  });

  factory PacientesCuidadores.fromJson(Map<String, dynamic> json){
    return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente']as String?,
      idPaciente: Pacientes.fromJson(json['IdPacienteNavigation']),
      idCuidador: Cuidadores.fromJson(json['IdCuidadorNavigation']),
      horaInicio: DateTime.parse(json['HoraInicio']as String),
      horaFin: DateTime.parse(json['HoraFin']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdCuidaPaciente': idCuidaPaciente ?? '',
      'IdPaciente': idPaciente.idPaciente,
      'IdCuidador': idCuidador.idCuidador,
      'HoraInicio': horaInicio,
      'HoraFin': horaFin,
    };
  }
}