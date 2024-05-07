import 'package:alzheimer_app1/models/geocercas.dart';

class Dispositivos{
  final String? idDispositivo;
  final Geocerca? idGeocerca;

  Dispositivos({
    this.idDispositivo,
    this.idGeocerca,
  });

  factory Dispositivos.fromJson(Map<String, dynamic> json){
    var geocerca;
    if(json['IdGeocercaNavigation']!=null){
      geocerca = Geocerca.fromJson(json['IdGeocercaNavigation']);
    }
    return Dispositivos(
      idDispositivo: json['IdDispositivo']as String,
      idGeocerca: geocerca,
      );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdDispositivo': idDispositivo ?? '',
      'IdGeocerca': idGeocerca?.idGeocerca,
    };
  }
}