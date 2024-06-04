import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class BuscadorPacientesScreen extends StatefulWidget {
  final Pacientes? paciente;
  const BuscadorPacientesScreen ({super.key, this.paciente});

  const BuscadorPacientesScreen.withoutPaciente ({super.key}) : paciente = null;

  @override
  _BuscadorPacientesScreenState createState() => _BuscadorPacientesScreenState();
}

class _BuscadorPacientesScreenState extends State<BuscadorPacientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allPatients = [
    'Juan Pérez',
    'María Gómez',
    'Carlos López',
    'Ana Martínez',
    'Pedro Sánchez',
  ];
  List<String> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients;
  }

  void _filterPatients(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = _allPatients;
      });
    } else {
      setState(() {
        _filteredPatients = _allPatients
            .where((patient) =>
                patient.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
              onChanged: _filterPatients,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPatients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredPatients[index]),
                );
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
