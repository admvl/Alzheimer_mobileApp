import 'package:alzheimer_app1/models/pacientes.dart';

class Medicamentos{
  final String? idMedicamento;
  final String nombre;
  final double gramaje;
  final String descripcion;
  final Pacientes idPaciente;

  Medicamentos({
    this.idMedicamento,
    required this.nombre,
    required this.gramaje,
    required this.descripcion,
    required this.idPaciente,
  });

  factory Medicamentos.fromJson(Map<String, dynamic>json){
    return Medicamentos(
      idMedicamento: json['IdPaciente'] as String,
      nombre: json['Nombre'] as String,
      gramaje: json['Gramaje'] as double,
      descripcion: json['Descripcion'] as String,
      idPaciente: Pacientes.fromJson(json['IdPaciente']),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'IdMedicamento': idMedicamento ?? '',
      'Nombre': nombre,
      'Gramaje': gramaje, 
      'Descripcion': descripcion,
      'IdPaciente': idPaciente.idPaciente,
    };
  }

}