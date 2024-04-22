import 'dart:ffi';

class Geocerca{
  final String? idGeocerca;
  final String coordenadaInicial;
  final Double radioGeocerca; // validar tipo dato
  final DateTime fecha; // validar tipo dato

  Geocerca({
    this.idGeocerca,
    required this.coordenadaInicial,
    required this.radioGeocerca,
    required this.fecha,
  });

  factory Geocerca.fromJson(Map<String,dynamic> json){
    return Geocerca(
      idGeocerca: json['IdGeocerca'] as String,
      coordenadaInicial: json['CoordenadaInicial'] as String,
      radioGeocerca: json['RadioGeocerca'] as Double,
      fecha: DateTime.parse(json['Fecha']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdGeocerca': idGeocerca ?? '',
      'CoordenadaInicial': coordenadaInicial,
      'RadioGeocerca': radioGeocerca,
      'Fecha': fecha,
    };
  }
}