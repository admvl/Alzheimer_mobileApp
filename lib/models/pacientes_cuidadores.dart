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
      idCuidaPaciente: json['idCuidaPaciente']as String,
      idPaciente: Pacientes.fromJson(json['idPaciente']),
      idCuidador: Cuidadores.fromJson(json['idCuidador']),
      horaInicio: DateTime.parse(json['horaInicio']as String),
      horaFin: DateTime.parse(json['horaFin']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'idCuidaPaciente': idCuidaPaciente ?? '',
      'idPaciente': idPaciente.toJson(),
      'idCuidador': idCuidador.toJson(),
      'horaInicio': horaInicio,
      'horaFin': horaFin,
    };
  }
}