import 'dart:convert';
import 'package:alzheimer_app1/models/LogIn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/Usuarios.dart'; // Importa tu clase Usuarios aquí
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class UsuariosService {
  final String baseUrl = "http://localhost:7084/api";

  UsuariosService();

  Future<void> login(LogIn usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      print(data['token']);
    } else if (response.statusCode == 401) {
      const SnackBar(content: Text("Contraseña incorrecta"));
    } else {
      const SnackBar(content: Text("Usuario no encontrado"));
    }
  }

  // Crear una nueva persona
  Future<Usuarios> crearUsuario(Usuarios nuevoUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearPersona'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoUsuario.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Usuarios.fromJson(jsonData);
    } else {
      throw Exception('Error al crear un nuevo Usuario');
    }
  }

  // Obtener una persona por ID
  Future<Usuarios> obtenerUsuarioPorId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Usuarios.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener persona por ID');
    }
  }

  // Actualizar una persona por ID
  Future<Usuarios> actualizarUsuarioPorId(
      String id, Usuarios usuarioActualizado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioActualizado.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Usuarios.fromJson(jsonData);
    } else {
      throw Exception('Error al actualizar usuario por ID');
    }
  }

  // Eliminar una persona por ID
  Future<bool> eliminarUsuarioPorId(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/usuarios/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar usuarios por ID');
    }
  }
}
