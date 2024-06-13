import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:alzheimer_app1/models/familiares.dart';

class PacientesFamiliaresService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.68.122:5066/api";

  PacientesFamiliaresService();

  //Obtener lista de familiares por ID de usuario
  Future<List<Familiares>> obtenerFamiliaresPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
        Uri.parse('$baseUrl/pacientefamiliares/$id'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Familiares> familiares = [];
      for (var item in jsonData) {
        familiares.add(Familiares.fromJson(item));
      }
      return familiares;
    } else {
      throw Exception('Error al obtener lista de familiares por ID');
    }
  }

  //Obtener todoas los pacientes por ID de usuario loggeado
  Future<List<Familiares>> obtenerTodosFamiliares() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/todosfamiliares/'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      //final Map<String, dynamic> jsonData = jsonDecode(response.body);
      //List<Pacientes> pacientes = jsonData.map((e) => Pacientes.fromJson(e)).toList();
      List<Familiares> familiares = [];
      for (var item in jsonData) {
        familiares.add(Familiares.fromJson(item));
      }
      return familiares;
      //return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener todos los familiares por ID');
    }
  }

  Future<PacientesFamiliares> crearPacienteFamiliar(
      PacientesFamiliares nuevaRelacion) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      //Uri.parse('$baseUrl/creapacientesfamiliares'),
      Uri.parse('$baseUrl/CrearRelacionFamiliares'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevaRelacion.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception('Error al crear relacion paciente - familiar');
    }
  }

  // Obtener una relacion por ID
  Future<PacientesFamiliares> obtenerPacienteFamiliarPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
        Uri.parse('$baseUrl/pacientesfamiliares/$id'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener relacion paciente - familiar por ID');
    }
  }

  // Obtener relaciones por ID
  Future<List<PacientesFamiliares>> obtenerPacienteFamiliaresPorId(
      String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
        Uri.parse('$baseUrl/pacientefamiliares/$id'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      //final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<PacientesFamiliares> pacientesFamiliares = [];
      for (var item in jsonData) {
        pacientesFamiliares.add(PacientesFamiliares.fromJson(item));
      }
      //return cuidadores;
      return pacientesFamiliares;
    } else {
      throw Exception('Error al obtener relacion paciente - familiares por ID');
    }
  }

  // Actualizar una persona por ID
  Future<PacientesFamiliares> actualizarPacienteFamiliarPorId(
      String id, PacientesFamiliares pacienteFamiliarActualizado) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/pacientesfamiliares/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(pacienteFamiliarActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception(
          'Error al actualizar relacion paciente - familiar por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPacienteFamiliarPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(
        Uri.parse('$baseUrl/pacientesfamiliares/$id'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar relacion paciente - familiar por ID');
    }
  }
}
