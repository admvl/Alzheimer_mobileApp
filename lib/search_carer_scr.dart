import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class BuscadorCuidadoresScreen extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;
  const BuscadorCuidadoresScreen ({super.key, this.paciente, this.usuario});

  const BuscadorCuidadoresScreen.withoutUsuario ({super.key, this.paciente}) :  usuario= null;

  @override
  _BuscadorCuidadoresScreenState createState() => _BuscadorCuidadoresScreenState();
}

class _BuscadorCuidadoresScreenState extends State<BuscadorCuidadoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Personas>> _allCaregivers;
  List<Personas> _filteredCaregivers = [];

  @override
  void initState() {
    super.initState();
    _allCaregivers = _findCaregivers(widget.paciente);
    _allCaregivers.then((caregivers) {
      setState(() {
        _filteredCaregivers = caregivers;
      });
    });
  }

  Future<List<Personas>> obtenerDetallesCuidadores(List<Cuidadores> cuidadores) async {
    List<Future<Personas>> futures = cuidadores.map((cuidador) => personaService.obtenerPersonaPorId(cuidador.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Personas>> _findCaregivers(Pacientes? paciente) async {
    if (paciente == null) return [];
    //cambiar para obtener todos los cuidadores existentes
    final cuidadores = await cuidadoresService.obtenerCuidadoresPorId(paciente.idPaciente!);
    if (cuidadores.isEmpty) return [];
    return await obtenerDetallesCuidadores(cuidadores);
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
        title: const Text('Buscador - Cuidadores'),
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
                labelText: 'Buscar cuidadores',
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
                  return const Center(child: Text('No hay cuidadores disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCaregivers.length,
                    itemBuilder: (context, index) {
                      final cuidador = _filteredCaregivers[index];
                      return ListTile(
                        title: Text('${cuidador.nombre ?? 'Sin detalle disponible'} ${cuidador.apellidoP} ${cuidador.apellidoM}'),
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
