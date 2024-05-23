
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:alzheimer_app1/models/familiares.dart';

class PacientesFamiliaresService{
  final String baseUrl = "http://192.168.68.124:5066/api";

  PacientesFamiliaresService();

  //Obtener lista de familiares por ID de usuario
  Future<List<PacientesFamiliares>> obtenerFamiliaresPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pacientesfamiliareslista/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<PacientesFamiliares> familiares = [];
      for (var item in jsonData) {
        familiares.add(PacientesFamiliares.fromJson(item));
      }
      return familiares;
    } else {
      throw Exception('Error al obtener lista de familiares por ID');
    }
  }

  Future<PacientesFamiliares> crearPacienteFamiliar(PacientesFamiliares nuevaRelacion) async{
    final response = await http.post(
      Uri.parse('$baseUrl/creapacientesfamiliares'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevaRelacion.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception ('Error al crear relacion paciente - familiar');
    }
  }

    // Obtener una relacion por ID
  Future<PacientesFamiliares> obtenerPacienteFamiliarPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pacientesfamiliares/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener relacion paciente - familiar por ID');
    }
  }

    // Actualizar una persona por ID
  Future<PacientesFamiliares> actualizarPacienteFamiliarPorId(String id, PacientesFamiliares pacienteFamiliarActualizado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pacientesfamiliares/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pacienteFamiliarActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PacientesFamiliares.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar relacion paciente - familiar por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarPacienteFamiliarPorId(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pacientesfamiliares/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar relacion paciente - familiar por ID');
    }
  }



  
}