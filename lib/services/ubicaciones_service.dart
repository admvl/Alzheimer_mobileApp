import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alzheimer_app1/models/ubicaciones.dart';

class UbicacionesService {
  final storage = const FlutterSecureStorage();
  //final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  final String baseUrl = "http://192.168.68.122:5066/api";


  //Obtener ubicacion
  Future<Ubicaciones> obtenerUbicacion(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/ubicacionesd/$id'),
        headers: {
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener ubicacion');
    }
  }

  //Obtener ubicacion Actualizada
  Future<Ubicaciones> obtenerUbicacionActualizada(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/ubicacion/$id'),
        headers: {
          'Authorization': 'Bearer $token'
        });
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
