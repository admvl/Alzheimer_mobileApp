
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alzheimer_app1/models/ubicaciones.dart';

class UbicacionesService{
  final String baseUrl =  "http://192.168.137.1:7084/api";

  UbicacionesService();

  //Crear nuevo ubicacion
  Future<Ubicaciones> crearUbicacion(Ubicaciones nuevaUbicacion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearUbicacion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevaUbicacion.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    }else{
      throw Exception('Error al crear nuevo ubicacion');
    }
  }

  //Obtener ubicacion
  
  Future<Ubicaciones> obtenerUbicacion(String id) async{
    final response = await http.get(Uri.parse('$baseUrl/ubicaciones/$id'));
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    }else{
      throw Exception('Error al obtener ubicacion');
    }
  }

  //Actualizar ubicacion
  Future<Ubicaciones> actualizarUbicacion(String id, Ubicaciones ubicacionActualizada) async{
    final response = await http.put(
      Uri.parse(('$baseUrl/ubicaciones/$id')),
      headers: {'Content--Type': 'application/json'},
      body: jsonEncode(ubicacionActualizada.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Ubicaciones.fromJson(jsonData);
    }else {
      throw Exception('Error al actualizar ubicacion');
    }
  }

  //Eliminar ubicacion
  Future<bool> eliminarUbicacion(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/ubicaciones/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar ubicacion');
    }
  }

}