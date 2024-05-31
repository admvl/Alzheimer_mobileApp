import 'dart:convert';

import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

class GeocercasService {
  final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  GeocercasService();

  //crear Geocerca
  Future<Geocerca> crearGeocerca(Geocerca nuevaGeocerca) async {
    final response = await http.post(
      Uri.parse('$baseUrl/crearGeocerca'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevaGeocerca.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Geocerca.fromJson(jsonData);
    } else {
      throw Exception('Error al crear una nueva Geocerca');
    }
  }

  //Actualizar geocerca
  Future<Geocerca> actualizarGeocerca(
      String id, Geocerca geocercaActualizada) async {
    final response = await http.put(
      Uri.parse(('$baseUrl/geocercas/$id')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(geocercaActualizada.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Geocerca.fromJson(jsonData);
    } else {
      throw Exception('Error al acctualizar geocerca');
    }
  }

  //obtener geocerca
  Future<Geocerca> obtenerGeocerca(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/geocercas/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Geocerca.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener geocerca');
    }
  }

  //Eliminar medicamento
  Future<bool> eliminarGeocerca(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/geocercas/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar geocerca');
    }
  }
}
