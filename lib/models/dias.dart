import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';

class Dias{
  final String? idDia;
  final DateTime dia;
  final PacientesCuidadores idCuidaPaciente;

  Dias({
    this.idDia,
    required this.dia,
    required this.idCuidaPaciente,
  });

  factory Dias.fromJson(Map<String, dynamic> json){
    return Dias(
      idDia: json['idDia'] as String,
      dia: DateTime.parse(json['dia'] as String),
      idCuidaPaciente: PacientesCuidadores.fromJson(json['idCuidaPaciente']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'idDia': idDia ?? '',
      'dia': dia,
      'idCuidaPaciente': idCuidaPaciente.toJson(),
    };
  }
}