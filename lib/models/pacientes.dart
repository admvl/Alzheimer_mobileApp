import 'package:alzheimer_app1/models/personas.dart';

class Pacientes{

  final String? idPaciente;
  final String? idDispositivo;
  final Personas idPersona;

  Pacientes({
    this.idPaciente,
    this.idDispositivo,
    required this.idPersona
  });

  factory Pacientes.fromJson(Map<String, dynamic> json){
    return Pacientes(
      idPaciente: json['idPaciente'] as String,
      idDispositivo: json['idDispositivo'] as String,
      idPersona: Personas.fromJson(json['idPersona']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'idPaciente': idPaciente ?? '',
      'idDispositivo': idDispositivo,
      'idPersona': idPersona.toJson(),
  };
  }
}