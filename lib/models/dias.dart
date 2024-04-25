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
      idDia: json['IdDia'] as String,
      dia: DateTime.parse(json['Dia'] as String),
      idCuidaPaciente: PacientesCuidadores.fromJson(json['IdCuidaPacienteNavigation']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'IdDia': idDia ?? '',
      'Dia': dia,
      'IdCuidaPaciente': idCuidaPaciente.idCuidaPaciente,
    };
  }
}