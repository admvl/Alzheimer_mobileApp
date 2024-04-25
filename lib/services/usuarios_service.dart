import 'dart:convert';
import 'package:alzheimer_app1/models/log_in.dart';
import 'package:http/http.dart' as http;
import '../models/tipos_usuarios.dart';
import '../models/users.dart';
import '../models/usuarios.dart'; // Importa tu clase Usuarios aquí
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class UsuariosService {
  final String baseUrl = "http://192.168.68.119:7084/api";

  UsuariosService();

  Future<http.Response> login(LogIn usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    return response;
  }
  // Crear una nueva persona
  Future<Usuarios> crearUsuario(Users nuevoUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearUsuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoUsuario.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Usuarios.fromJson(jsonData);
    } else {
      throw Exception('Error al crear un nuevo Usuario');
    }
  }
  // Actualizar una nueva persona
  Future<Usuarios> actualizarUsuario(Users actualizarUsuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/${actualizarUsuario.usuario.idUsuario}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(actualizarUsuario.toJson()),
    );

    if (response.statusCode == 200) {
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
  Future<TiposUsuarios> obtenerTipoUsuario(String tipoUsuario) async{
    final response = await http.get(Uri.parse('$baseUrl/tiposusuarios/$tipoUsuario'));

    if(response.statusCode == 200){
      final Map<String,dynamic> jsonData = jsonDecode(response.body);
      return TiposUsuarios.fromJson(jsonData);
    }else{
      throw Exception('Error al obtener el tipo de usuario');
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
