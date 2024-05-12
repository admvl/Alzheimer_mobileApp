

class Geocerca{
  final String? idGeocerca;
  final double radioGeocerca; // validar tipo dato
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
      idGeocerca: json['IdGeocerca'] as String?,
      radioGeocerca: (json['RadioGeocerca'] as num).toDouble(),
      fecha: DateTime.parse(json['Fecha']as String),
      latitude: json['Latitud'] as double,
      longitude: json['Longitud'] as double,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(idGeocerca!=null)'IdGeocerca': idGeocerca,
      'Latitud': latitude,
      'Longitud': longitude,
      'RadioGeocerca': radioGeocerca,
      'Fecha': fecha.toIso8601String(),
    };
  }
}