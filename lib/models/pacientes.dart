import 'package:alzheimer_app1/models/dispositivos.dart';
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
      idPaciente: json['IdPaciente'] as String,
      idDispositivo: Dispositivos.fromJson(json['IdDispositivoNavigation']),
      idPersona: Personas.fromJson(json['IdPersonaNavigation']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'IdPaciente': idPaciente ?? '',
      'IdDispositivo': idDispositivo.idDispositivo,
      'IdPersona': idPersona.idPersona,
  };
  }
}