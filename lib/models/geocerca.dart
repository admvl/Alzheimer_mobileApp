import 'dart:ffi';

class Geocerca{
  final String? idGeocerca;
  final String coordenadaInicial;
  final Float radioGeocerca; // validar tipo dato
  final DateTime fecha; // validar tipo dato

  Geocerca({
    this.idGeocerca,
    required this.coordenadaInicial,
    required this.radioGeocerca,
    required this.fecha,
  });

  factory Geocerca.fromJson(Map<String,dynamic> json){
    return Geocerca(
      idGeocerca: json['idGeocerca'] as String,
      coordenadaInicial: json['coordenadaInicial'] as String,
      radioGeocerca: json['radioGeocerca'] as Float,
      fecha: DateTime.parse(json['fecha']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'idGeocerca': idGeocerca ?? '',
      'coordenadaInicial': coordenadaInicial,
      'radioGeocerca': radioGeocerca,
      'fecha': fecha,
    };
  }
}