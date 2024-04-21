import 'package:alzheimer_app1/models/geocerca.dart';

class Dispositivos{
  final String? idDispositivo;
  final Geocerca idGeocerca;

  Dispositivos({
    this.idDispositivo,
    required this.idGeocerca,
  });

  factory Dispositivos.fromJson(Map<String, dynamic> json){
    return Dispositivos(
      idDispositivo: json['idDispositivo']as String,
      idGeocerca: Geocerca.fromJson(json['idGeocerca']),
      );
  }

  Map<String, dynamic> toJson(){
    return{
      'idDispositivo': idDispositivo ?? '',
      'idGeocerca': idGeocerca.toJson(),
    };
  }
}