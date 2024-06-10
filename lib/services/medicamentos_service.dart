import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:alzheimer_app1/models/medicamentos.dart';

class MedicamentosService {
  final storage = FlutterSecureStorage();
  //final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  final String baseUrl = "http://192.168.68.122:5066/api";

  MedicamentosService();

  //Crear nuevo medicamento
  Future<Medicamentos> crearMedicamento(Medicamentos nuevoMedicamento) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/CrearMedicamento'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevoMedicamento.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    } else {
      throw Exception('Error al crear nuevo medicamento');
    }
  }

  //Obtener medicamento
  Future<Medicamentos> obtenerMedicamento(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/medicamentos/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener persona');
    }
  }

  Future<List<Medicamentos>> obtenerMedicamentosPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await http.get(Uri.parse('$baseUrl/medicamentospaciente/$id'),
          headers: {
            'Authorization': 'Bearer $token'
          });
    //List<Medicamentos> medicamentos = [];
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Medicamentos> medicamentos = [];
      for (var item in jsonData) {
        medicamentos.add(Medicamentos.fromJson(item));
      }
      return medicamentos;
    } else {
      throw Exception('Error al obtener lista de medicamentos por ID');
    }
  }

  //Actualizar medicamento
  Future<Medicamentos> actualizarMedicamento(
      String id, Medicamentos medicamentoActualizado) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse(('$baseUrl/medicamentos/$id')),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(medicamentoActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    } else {
      throw Exception('Error al acctualizar medicamento');
    }
  }

  //Eliminar medicamento
  Future<bool> eliminarMedicamento(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(Uri.parse('$baseUrl/medicamentos/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar medicamento');
    }
  }
}
