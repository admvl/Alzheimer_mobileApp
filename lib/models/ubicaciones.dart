//import 'dart:html';

import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ubicaciones{
  final String? idUbicacion;
  final double latitude;
  final double longitude;
  final DateTime fechaHora;
  final Dispositivos idDispositivo;

  Ubicaciones({
    this.idUbicacion,
    required this.latitude,
    required this.longitude,
    required this.fechaHora,
    required this.idDispositivo,
  });

  factory Ubicaciones.fromJson(Map<String, dynamic> json) {
    return Ubicaciones(
      idUbicacion: json['IdUbicacion'] as String?,
      latitude: json['latitude'],
      longitude: json['longitude'],
      fechaHora: DateTime.parse(json['FechahHora']),
      idDispositivo: Dispositivos.fromJson(json['IdDispositivoNavigation']),
    );
  }
  Map<String, dynamic> toJson(){
    return{
      if(idUbicacion!=null)'IdUbicación': idUbicacion,
      'Latitude': latitude,
      'Longitude': longitude,
      'FechaHora': fechaHora,
      if(idDispositivo.idDispositivo!=null)'IdDispositivo': idDispositivo.idDispositivo,
    };
  }

}