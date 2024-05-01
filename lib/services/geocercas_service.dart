
import 'dart:convert';

import 'package:alzheimer_app1/models/geocercas.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

class GeocercasService{

  final String baseUrl = "http://192.168.0.10:7084/api";
  GeocercasService();

  //crear Geocerca
  Future<Geocerca> crearGeocerca(Geocerca nuevaGeocerca) async{
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

  //actualizar geocerca
  Future<Geocerca> actualizarGeocerca(Geocerca actualizaGeocerca) async{
    final response = await http.put(
      //Uri.parse('$baseUrl/geocerca/${actualizaGeocerca.}')
    ),
  }

}