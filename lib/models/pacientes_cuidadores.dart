import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/dias.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:intl/intl.dart';

class PacientesCuidadores{
  final String? idCuidaPaciente;
  final Pacientes idPaciente;
  final Cuidadores idCuidador;
  final DateTime horaInicio;
  final DateTime horaFin;
  final Dias? dias;
  
  
  PacientesCuidadores({
    this.idCuidaPaciente,
    required this.idPaciente,
    required this.idCuidador,
    required this.horaInicio,
    required this.horaFin,
    this.dias,
  });

  /*
  factory PacientesCuidadores.fromJson(Map<String, dynamic> json){
    return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente']as String?,
      idPaciente: Pacientes.fromJson(json['IdPacienteNavigation']),
      idCuidador: Cuidadores.fromJson(json['IdCuidadorNavigation']),
      horaInicio: DateTime.parse(json['HoraInicio']as String),
      horaFin: DateTime.parse(json['HoraFin']as String),
      dias: json['Dia'] != null ? Dias.fromJson(json['Dia']) : null,

    );
  }*/
  factory PacientesCuidadores.fromJson(Map<String, dynamic> json){
  return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente'] as String?,
      idPaciente: Pacientes.fromJson(json['IdPacienteNavigation']),
      idCuidador: Cuidadores.fromJson(json['IdCuidadorNavigation']),
      horaInicio: DateTime.parse(json['HoraInicio'] as String? ?? '2000-01-01T00:00:00Z'),
      horaFin: DateTime.parse(json['HoraFin'] as String? ?? '2000-01-01T00:00:00Z'),
      dias: json['Dia'] != null ? Dias.fromJson(json['Dia'] as Map<String, dynamic>) : null,
    );
  }
  

  Map<String, dynamic> toJson(){
    return{
      'IdCuidaPaciente': idCuidaPaciente ?? '',
      'IdPaciente': idPaciente.idPaciente,
      'IdCuidador': idCuidador.idCuidador,
      'HoraInicio': horaInicio,
      'HoraFin': horaFin,
      'Dia': dias!.dia,
    };
  }
}