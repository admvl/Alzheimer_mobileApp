import 'package:alzheimer_app1/models/dispositivo.dart';
import 'package:alzheimer_app1/models/personas.dart';

class Pacientes{

  final String? idPaciente;
  final Dispositivos idDispositivo;
  final Personas idPersona;

  Pacientes({
    this.idPaciente,
    required this.idDispositivo,
    required this.idPersona
  });

  factory Pacientes.fromJson(Map<String, dynamic> json){
    return Pacientes(
      idPaciente: json['idPaciente'] as String,
      idDispositivo: Dispositivos.fromJson(json['idDispositivo']),
      idPersona: Personas.fromJson(json['idPersona']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'idPaciente': idPaciente ?? '',
      'idDispositivo': idDispositivo.toJson(),
      'idPersona': idPersona.toJson(),
  };
  }
}