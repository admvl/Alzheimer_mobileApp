
class Ubicaciones{
  final String? idUbicacion;
  final double latitude;
  final double longitude;
  final DateTime fechaHora;
  final String idDispositivo;

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
      latitude: json['Latitud'],
      longitude: json['Longitud'],
      fechaHora: DateTime.parse(json['FechaHora'] as String),
      idDispositivo: json['IdDispositivo'] as String//Dispositivos.fromJson(json['IdDispositivoNavigation']),
    );
  }
  Map<String, dynamic> toJson(){
    return{
      if(idUbicacion!=null)'IdUbicación': idUbicacion,
      'Latitude': latitude,
      'Longitude': longitude,
      'FechaHora': fechaHora,
      'IdDispositivo': idDispositivo,
    };
  }

}