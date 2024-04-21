import 'package:alzheimer_app1/models/cuidadores.dart';

class PacientesCuidadores{
  final String? idCuidaPaciente;
  final String? idPaciente;
  final Cuidadores idCuidador;
  final DateTime horaInicio;
  final DateTime horaFin;
  
  
  PacientesCuidadores({
    this.idCuidaPaciente,
    this.idPaciente,
    required this.idCuidador,
    required this.horaInicio,
    required this.horaFin,
  });

  factory PacientesCuidadores.fromJson(Map<String, dynamic> json){
    return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente']as String,
      idPaciente: json['IdPaciente']as String,
      idCuidador: Cuidadores.fromJson(json['IdCuidador']),
      horaInicio: DateTime.parse(json['HoraInicio']as String),
      horaFin: DateTime.parse(json['HoraFin']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdCuidaPaciente': idCuidaPaciente,
      'IdPaciente': idPaciente,
      'IdCuidador': idCuidador.toJson(),
      'HoraInicio': horaInicio,
      'HoraFin': horaFin,
    };
  }
}