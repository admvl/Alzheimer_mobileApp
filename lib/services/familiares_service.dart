import 'dart:convert';
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:http/http.dart' as http;

class FamiliaresService {
  //final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  final String baseUrl = "http://192.168.0.15:5066/api";

  FamiliaresService();

  // Crear una nuevo paciente
  Future<Familiares> crearFamiliar(Familiares nuevoFamiliar) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearFamiliar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoFamiliar.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Familiares.fromJson(jsonData);
    } else {
      throw Exception('Error al crear una nuevo familiar');
    }
  }

  // Obtener una persona por ID
  Future<Familiares> obtenerFamiliarPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/familiares/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Familiares.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener familiar por ID');
    }
  }

  //Obtener todoas los pacientes por ID de usuario loggeado
  Future<List<Familiares>> obtenerTodosFamiliares(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/todosfamiliares/$id'));

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
  
  //Obtener pacientes por ID de usuario loggeado
  Future<List<Familiares>> obtenerPacientesPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/familiares/$id'));

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
      throw Exception('Error al obtener familiares por ID');
    }
  }

  // Actualizar una persona por ID
  Future<Familiares> actualizarFamiliarPorId(String id, Familiares familiarActualizado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/familiares/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(familiarActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Familiares.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar familiar por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarFamiliarPorId(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/familiares/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar familiar por ID');
    }
  }
}
