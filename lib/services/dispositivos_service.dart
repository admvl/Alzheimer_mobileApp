import 'dart:convert';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:http/http.dart' as http;

class DispositivosService {
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";

  DispositivosService();

  //Actualizar geocerca
  Future<Dispositivos> actualizarDispositivos(
      String id, Dispositivos dispositivoActualizado) async {
    final response = await http.put(
      Uri.parse(('$baseUrl/dispositivos/$id')),
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/dispositivos/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dispositivos.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener dispositivo por ID');
    }
  }

  Future<List<Dispositivos>> obtenerDispositivos() async {
    final response = await http.get(Uri.parse('$baseUrl/dispositivos/'));

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
}
