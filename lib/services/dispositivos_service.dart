import 'dart:convert';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DispositivosService {
  final storage = FlutterSecureStorage();
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  //final String baseUrl = "http://192.168.68.122:5066/api";

  DispositivosService();

  // Crear una nuevo dispositivo
  Future<Dispositivos> crearDispositivo(Dispositivos nuevoDispositivo) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/CrearDispositivo'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(nuevoDispositivo.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dispositivos.fromJson(jsonData);
    } else {
      throw Exception('Error al crear una nuevo Dispositivo');
    }
  }

  //Actualizar geocerca
  Future<Dispositivos> actualizarDispositivos(
      String id, Dispositivos dispositivoActualizado) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse(('$baseUrl/dispositivos/$id')),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(dispositivoActualizado.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dispositivos.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar dispositivo');
    }
  }

  // Obtener una persona por ID
  Future<Dispositivos> obtenerDispositivoPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/dispositivos/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dispositivos.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener dispositivo por ID');
    }
  }

  Future<List<Dispositivos>> obtenerDispositivos() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/dispositivos/'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Dispositivos> dispositivos = [];
      for (var item in jsonData) {
        dispositivos.add(Dispositivos.fromJson(item));
      }
      return dispositivos;
    } else {
      throw Exception('Error al obtener dispositivos');
    }
  }

  // Eliminar un dispositivo por ID
  Future<bool> eliminarDispositivoPorId(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.delete(Uri.parse('$baseUrl/dispositivos/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar dispositivo por ID');
    }
  }
}
