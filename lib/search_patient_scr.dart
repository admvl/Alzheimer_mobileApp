import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class BuscadorPacientesScreen extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;

  const BuscadorPacientesScreen ({super.key, this.paciente, this.usuario});

  const BuscadorPacientesScreen.withoutUsuario ({super.key, this.paciente}) : usuario = null;

  @override
  _BuscadorPacientesScreenState createState() => _BuscadorPacientesScreenState();
}

class _BuscadorPacientesScreenState extends State<BuscadorPacientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Personas>> _allCaregivers;
  List<Personas> _filteredCaregivers = [];

  @override
  void initState() {
    super.initState();
    _allCaregivers = _findCaregivers(widget.paciente, widget.usuario);
    _allCaregivers.then((caregivers) {
      setState(() {
        _filteredCaregivers = caregivers;
      });
    });
  }

  Future<List<Personas>> obtenerDetallesPacientes(List<Pacientes> pacientes) async {
    List<Future<Personas>> futures = pacientes.map((paciente) => personaService.obtenerPersonaPorId(paciente.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Personas>> _findCaregivers(Pacientes? paciente, Usuarios? usuario) async {
    if (paciente == null) return [];
    //cambiar para obtener todos los pacientes existentes
    final cuidadores = await pacientesService.obtenerPacientesPorId(usuario!.idUsuario!);
    if (cuidadores.isEmpty) return [];
    return await obtenerDetallesPacientes(cuidadores);
  }

  void _filterCaregivers(String query) {
    if (query.isEmpty) {
      _allCaregivers.then((caregivers) {
        setState(() {
          _filteredCaregivers = caregivers;
        });
      });
    } else {
      _allCaregivers.then((caregivers) {
        setState(() {
          _filteredCaregivers = caregivers.where((caregiver) {
            final words = caregiver.nombre!.split(' ') + caregiver.apellidoP.split(' ') + caregiver.apellidoM.split(' ');
            return words.any((word) => word.toLowerCase().contains(query.toLowerCase()));
          }).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Buscador - Pacientes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar pacientes',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCaregivers,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Personas>>(
              future: _allCaregivers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay pacientes disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCaregivers.length,
                    itemBuilder: (context, index) {
                      final paciente = _filteredCaregivers[index];
                      return ListTile(
                        title: Text('${paciente.nombre ?? 'Sin detalle disponible'} ${paciente.apellidoP} ${paciente.apellidoM}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
