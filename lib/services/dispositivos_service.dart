import 'dart:convert';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:http/http.dart' as http;

class DispositivosService {
  final String baseUrl = "http://192.168.0.2:7084/api";

  DispositivosService();


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
      for(var item in jsonData){
        dispositivos.add(Dispositivos.fromJson(item));
      }
      return dispositivos;
    } else {
      throw Exception('Error al obtener dispositivos');
    }
  }
}
