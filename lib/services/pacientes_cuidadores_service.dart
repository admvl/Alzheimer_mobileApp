import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pacientes_cuidadores.dart';

class PacientesCuidadoresService {
  final storage = FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.68.122:5066/api";

  PacientesCuidadoresService();

  //Obtener lista de familiares por ID de usuario
  Future<List<Cuidadores>> obtenerCuidadoresPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await http.get(Uri.parse('$baseUrl/pacientecuidadores/$id'),
          headers: {
            'Authorization': 'Bearer $token'
          });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Cuidadores> cuidadores = [];
      for (var item in jsonData) {
        cuidadores.add(Cuidadores.fromJson(item));
      }
      return cuidadores;
    } else {
      throw Exception('Error al obtener lista de familiares por ID');
    }
  }

  //Obtener lista de todos los cuidadores
  Future<List<Cuidadores>> obtenerTodosCuidadores() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/todoscuidadores/'),
        headers: {
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Cuidadores> cuidadores = [];
      for (var item in jsonData) {
        cuidadores.add(Cuidadores.fromJson(item));
      }
      return cuidadores;
    } else {
      throw Exception('Error al obtener lista de todos los cuidadores');
    }
  }

  Future<PacientesCuidadores> crearPacienteCuidador(PacientesCuidadores nuevaRelacion) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/CrearRelacion'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevaRelacion.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception('Error al crear relacion paciente - cuidador');
    }
  }

  // Obtener una relacion por ID
  Future<PacientesCuidadores> obtenerPacienteCuidadorPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await http.get(Uri.parse('$baseUrl/pacientescuidadores/$id'),
          headers: {
            'Authorization': 'Bearer $token'
          });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener relacion paciente - cuidador por ID');
    }
  }

  // Actualizar una persona por ID
  Future<PacientesCuidadores> actualizarPacienteCuidadorPorId(
      String id, PacientesCuidadores pacienteCuidadorActualizado) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/pacientescuidadores/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(pacienteCuidadorActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception(
          'Error al actualizar relacion paciente - Cuidador por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPacienteCuidadorPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await http.delete(Uri.parse('$baseUrl/pacientescuidadores/$id'),
          headers: {
            'Authorization': 'Bearer $token'
          });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar relacion paciente - cuidador por ID');
    }
  }
}
