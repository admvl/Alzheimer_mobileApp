//import 'dart:html';

import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ubicaciones{
  final String? idUbicacion;
  final LatLng? ubicacion;
  final DateTime fechaHora;
  final Dispositivos idDispositivo;

  Ubicaciones({
    this.idUbicacion,
    required this.ubicacion,
    required this.fechaHora,
    required this.idDispositivo,
  });

  factory Ubicaciones.fromJson(Map<String,dynamic> json){
    final latitude = json['Ubicacion']?['latitude'] as double?;
    final longitude = json['Ubicacion']?['longitude'] as double?;
    final latLng = latitude != null && longitude != null ? LatLng(latitude, longitude) : null;

    return Ubicaciones(
      idUbicacion: json['IdUbicacion'] as String?,
      ubicacion: latLng,
      fechaHora: DateTime.parse(json['FechahHora']),
      idDispositivo: Dispositivos.fromJson(json['IdDispositivoNavigation']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(idUbicacion!=null)'IdUbicación': idUbicacion,
      'Ubicacion': ubicacion?.toString(),
      'FechaHora': fechaHora,
      if(idDispositivo.idDispositivo!=null)'IdDispositivo': idDispositivo.idDispositivo,
      //'IdDispositivo': idDispositivo.idDispositivo,
    };
  }

}