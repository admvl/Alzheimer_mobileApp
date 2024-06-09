import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';

class Dias{
  final String? idDia;
  final String idCuidaPaciente;
  final bool lunes;
  final bool martes;
  final bool miercoles;
  final bool jueves;
  final bool viernes;
  final bool sabado;
  final bool domingo;

  Dias({
    this.idDia,
    required this.idCuidaPaciente,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.sabado,
    required this.domingo,
  });

  /*
  factory Dias.fromJson(Map<String, dynamic> json){
    return Dias(
      idDia: json['IdDia'] as String,
      dia: DateTime.parse(json['Dia'] as String),
      idCuidaPaciente: PacientesCuidadores.fromJson(json['IdCuidaPacienteNavigation']),
    );
  }*/
  factory Dias.fromJson(Map<String, dynamic> json){
  return Dias(
      idDia: json['IdDia'] as String?,
      idCuidaPaciente: json['IdCuidaPaciente'] as String,
      lunes: json['Lunes'] as bool,
      martes: json['Martes'] as bool,
      miercoles: json['Miercoles'] as bool,
      jueves: json['Jueves'] as bool,
      viernes: json['Viernes'] as bool,
      domingo: json['Domingo'] as bool,
      sabado: json['Sabado'] as bool,
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'IdDia': idDia ?? '',
      'IdCuidaPaciente': idCuidaPaciente,
      'Lunes': lunes,
      'Martes': martes,
      'Miercoles': miercoles,
      'Jueves': jueves,
      'Viernes': viernes,
      'Sabado': sabado,
      'Domingo': domingo,
    };
  }
}