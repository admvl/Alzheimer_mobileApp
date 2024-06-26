import 'dart:convert';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PacientesService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.68.108:5066/api";

  PacientesService();

  // Crear una nuevo paciente
  Future<Pacientes> crearPersona(Pacientes nuevoPaciente) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/CrearPaciente'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevoPaciente.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al crear una nuevo paciente');
    }
  }

  // Obtener una persona por ID
  Future<Pacientes> obtenerPacientePorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/pacientes/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener paciente por ID');
    }
  }

  //Obtener todoas los pacientes por ID de usuario loggeado
  Future<List<Pacientes>> obtenerTodosPacientes() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/todospacientes/'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      //final Map<String, dynamic> jsonData = jsonDecode(response.body);
      //List<Pacientes> pacientes = jsonData.map((e) => Pacientes.fromJson(e)).toList();
      List<Pacientes> pacientes = [];
      for (var item in jsonData) {
        pacientes.add(Pacientes.fromJson(item));
      }
      return pacientes;
      //return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener todos los pacientes por ID');
    }
  }

  //Obtener pacientes por ID de usuario loggeado
  Future<List<Pacientes>> obtenerPacientesPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/pacienteslista/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      //final Map<String, dynamic> jsonData = jsonDecode(response.body);
      //List<Pacientes> pacientes = jsonData.map((e) => Pacientes.fromJson(e)).toList();
      List<Pacientes> pacientes = [];
      for (var item in jsonData) {
        pacientes.add(Pacientes.fromJson(item));
      }
      return pacientes;
      //return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener paciente por ID');
    }
  }

  // Actualizar una persona por ID
  Future<Pacientes> actualizarPacientePorId(
      String id, Pacientes pacienteActualizado) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/pacientes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(pacienteActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar paciente por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPacientePorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(Uri.parse('$baseUrl/pacientes/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar perpacientesona por ID');
    }
  }
}
