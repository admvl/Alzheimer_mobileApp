import 'dart:convert';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:http/http.dart' as http;


class PacientesService {
  final String baseUrl = "http://192.168.137.1:7084/api";

  PacientesService();

  // Crear una nuevo paciente
  Future<Pacientes> crearPersona(Pacientes nuevoPaciente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearPaciente'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/pacientes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Pacientes.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener paciente por ID');
    }
  }

  // Actualizar una persona por ID
  Future<Pacientes> actualizarPacientePorId(
      String id, Pacientes pacienteActualizado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pacientes/$id'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.delete(Uri.parse('$baseUrl/pacientes/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar perpacientesona por ID');
    }
  }
}
