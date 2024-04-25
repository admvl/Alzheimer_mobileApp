import 'dart:html';

import 'package:alzheimer_app1/models/dispositivos.dart';

class Ubicaciones{
  final String? idUbicacion;
  final String ubicacion;
  final DateTime fechaHora;
  final Dispositivos idDispositivo;

  Ubicaciones({
    this.idUbicacion,
    required this.ubicacion,
    required this.fechaHora,
    required this.idDispositivo,
  });

  factory Ubicaciones.fromJson(Map<String,dynamic> json){
    return Ubicaciones(
      idUbicacion: json['IdUbicacion'] as String,
      ubicacion: json['Ubicacion'] as String,
      fechaHora: json['FechahHora'] as DateTime, //validar tipo dedato
      idDispositivo: Dispositivos.fromJson(json['IdDispositivoNavigation']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdUbicación': idUbicacion ?? '',
      'Ubicacion': ubicacion,
      'FechaHora': fechaHora,
      'IdDispositivo': idDispositivo.idDispositivo,
    };
  }

}