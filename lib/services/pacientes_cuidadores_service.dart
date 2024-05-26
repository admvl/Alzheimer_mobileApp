
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pacientes_cuidadores.dart';

class PacientesCuidadoresService{
  final String baseUrl = "http://192.168.137.1:5066/api";

  PacientesCuidadoresService();

  //Obtener lista de familiares por ID de usuario
  Future<List<PacientesCuidadores>> obtenerCuidadoresPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pacientescuidadoreslista/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<PacientesCuidadores> cuidadores = [];
      for (var item in jsonData) {
        cuidadores.add(PacientesCuidadores.fromJson(item));
      }
      return cuidadores;
    } else {
      throw Exception('Error al obtener lista de familiares por ID');
    }
  }

  Future<PacientesCuidadores> crearPacienteCuidador(PacientesCuidadores nuevaRelacion) async{
    final response = await http.post(
      Uri.parse('$baseUrl/creapacientescuidadores'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevaRelacion.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception ('Error al crear relacion paciente - cuidador');
    }
  }

    // Obtener una relacion por ID
  Future<PacientesCuidadores> obtenerPacienteCuidadorPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pacientescuidadores/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener relacion paciente - cuidador por ID');
    }
  }

    // Actualizar una persona por ID
  Future<PacientesCuidadores> actualizarPacienteCuidadorPorId(String id, PacientesCuidadores pacienteCuidadorActualizado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pacientescuidadores/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pacienteCuidadorActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesCuidadores.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar relacion paciente - Cuidador por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPacienteCuidadorPorId(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pacientescuidadores/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar relacion paciente - cuidador por ID');
    }
  }



  
}