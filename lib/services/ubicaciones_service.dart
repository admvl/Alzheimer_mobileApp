
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alzheimer_app1/models/ubicaciones.dart';

class UbicacionesService{
  final String baseUrl =  "http://172.100.74.165:7084/api";

  UbicacionesService();

  //Obtener ubicacion
  Future<Ubicaciones> obtenerUbicacion(String id) async{
    final response = await http.get(Uri.parse('$baseUrl/ubicacionesd/$id'));
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    }else{
      throw Exception('Error al obtener ubicacion');
    }
  }

}