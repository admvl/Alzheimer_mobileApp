import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alzheimer_app1/models/ubicaciones.dart';

class UbicacionesService {
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";

  UbicacionesService();

  //Obtener ubicacion
  Future<Ubicaciones> obtenerUbicacion(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/ubicacionesd/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener ubicacion');
    }
  }

  //Obtener ubicacion Actualizada
  Future<Ubicaciones> obtenerUbicacionActualizada(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/ubicacion/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    } else if (response.statusCode == 500) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener ubicacion');
    }
  }
}
