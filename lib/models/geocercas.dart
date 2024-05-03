import 'dart:ffi';

class Geocerca{
  final String? idGeocerca;
  final Double radioGeocerca; // validar tipo dato
  final DateTime fecha; // validar tipo dato
  final double latitude;
  final double longitude;

  Geocerca({
    this.idGeocerca,
    required this.radioGeocerca,
    required this.fecha,
    required this.latitude,
    required this.longitude,
  });

  factory Geocerca.fromJson(Map<String,dynamic> json){
    return Geocerca(
      idGeocerca: json['IdGeocerca'] as String,
      radioGeocerca: json['RadioGeocerca'] as Double,
      fecha: DateTime.parse(json['Fecha']as String),
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdGeocerca': idGeocerca ?? '',
      'Latitude': latitude,
      'Longitude': longitude,
      'RadioGeocerca': radioGeocerca,
      'Fecha': fecha,
    };
  }
}