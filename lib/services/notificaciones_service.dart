import 'dart:convert';
import 'package:alzheimer_app1/models/notificaciones.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NotificacionesService {
  final storage = const FlutterSecureStorage();
  //final String baseUrl = "https://alzheimerwebapi.azurewebsites.net/api";
  final String baseUrl = "http://192.168.68.122:5066/api";

  NotificacionesService();

  // Obtener todas las notificaciones
  Future<List<Notificaciones>> obtenerNotificaciones(String id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(Uri.parse('$baseUrl/notificaciones/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Notificaciones> notificaciones = [];
      for (var item in jsonData) {
        notificaciones.add(Notificaciones.fromJson(item));
      }
      return notificaciones;
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }
}
