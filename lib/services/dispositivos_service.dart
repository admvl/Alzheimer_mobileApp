import 'dart:convert';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:http/http.dart' as http;

class DispositivosService {
  final String baseUrl = "http://192.168.0.2:7084/api";

  DispositivosService();

  //Actualizar geocerca
  Future<Dispositivos> actualizarDispositivos(String id, Dispositivos dispositivoActualizado) async{
    final response = await http.put(
      Uri.parse(('$baseUrl/dispositivo/$id')),
      headers: {'Content--Type': 'application/json'},
      body: jsonEncode(dispositivoActualizado.toJson()),
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Dispositivos.fromJson(jsonData);
    }else {
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
}
