import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/personas.dart'; // Importa tu clase Personas aquí

class PersonasService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.68.108:5066/api";

  PersonasService();

  // Crear una nueva persona
  Future<Personas> crearPersona(Personas nuevaPersona) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/CrearPersona'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevaPersona.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Personas.fromJson(jsonData);
    } else {
      throw Exception('Error al crear una nueva persona');
    }
  }

  // Obtener una persona por ID
  Future<Personas> obtenerPersonaPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/personas/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Personas.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener persona por ID');
    }
  }

  // Actualizar una persona por ID
  Future<Personas> actualizarPersonaPorId(
      String id, Personas personaActualizada) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/personas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(personaActualizada.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Personas.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar persona por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPersonaPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(Uri.parse('$baseUrl/personas/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar persona por ID');
    }
  }
}
