
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alzheimer_app1/models/medicamentos.dart';

class MedicamentosService{
  final String baseUrl = "http://192.168.137.1:5066/api";

  MedicamentosService();

  //Crear nuevo medicamento
  Future<Medicamentos> crearMedicamento(Medicamentos nuevoMedicamento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CrearMedicamento'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nuevoMedicamento.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    }else{
      throw Exception('Error al crear nuevo medicamento');
    }
  }

  //Obtener medicamento
  Future<Medicamentos> obtenerMedicamento(String id) async{
    final response = await http.get(Uri.parse('$baseUrl/medicamentos/$id'));
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    }else{
      throw Exception('Error al obtener persona');
    }
  }

  //Actualizar medicamento
  Future<Medicamentos> actualizarMedicamento(String id, Medicamentos medicamentoActualizado) async{
    final response = await http.put(
      Uri.parse(('$baseUrl/medicamentos/$id')),
      headers: {'Content--Type': 'application/json'},
      body: jsonEncode(medicamentoActualizado.toJson()),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Medicamentos.fromJson(jsonData);
    }else {
      throw Exception('Error al acctualizar medicamento');
    }
  }

  //Eliminar medicamento
  Future<bool> eliminarMedicamento(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/medicamentos/$id'));

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar medicamento');
    }
  }

}