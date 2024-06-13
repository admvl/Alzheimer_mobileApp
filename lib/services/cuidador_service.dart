import 'dart:convert';
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CuidadorService {
  final storage = FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.56.1:5066/api";

  CuidadorService();


// Eliminar una persona por ID
  Future<bool> eliminarCuidadorPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(Uri.parse('$baseUrl/cuidadores/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar cuidador por ID');
    }
  }

}