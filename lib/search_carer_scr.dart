/*import 'package:flutter/material.dart';

class BuscadorCuidadoresScreen extends StatelessWidget {
  const BuscadorCuidadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Cuidadores'),
      ),
      body: const Center(
        child: Text('Pantalla de búsqueda de cuidadores'),
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';


class BuscadorCuidadoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Familiares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allCaregivers = [
    'Juan Pérez',
    'María Gómez',
    'Carlos López',
    'Ana Martínez',
    'Pedro Sánchez',
  ];
  List<String> _filteredCaregivers = [];

  @override
  void initState() {
    super.initState();
    _filteredCaregivers = _allCaregivers;
  }

  void _filterCaregivers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCaregivers = _allCaregivers;
      });
    } else {
      setState(() {
        _filteredCaregivers = _allCaregivers
            .where((caregiver) =>
                caregiver.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador - Cuidadores'),
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
            child: ListView.builder(
              itemCount: _filteredCaregivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCaregivers[index]),
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

*/

import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/patient_mgmt_scr.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class BuscadorCuidadoresScreen extends StatefulWidget {
  final Pacientes? paciente;
  const BuscadorCuidadoresScreen ({super.key, this.paciente});

  const BuscadorCuidadoresScreen.withoutPaciente ({super.key}) : paciente = null;

  @override
  _BuscadorCuidadoresScreenState createState() => _BuscadorCuidadoresScreenState();
}

class _BuscadorCuidadoresScreenState extends State<BuscadorCuidadoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allCaregivers = [
    'Juan Pérez',
    'María Gómez',
    'Carlos López',
    'Ana Martínez',
    'Pedro Sánchez',
  ];
  List<String> _filteredCaregivers = [];

  @override
  void initState() {
    super.initState();
    _filteredCaregivers = _allCaregivers;
  }

  void _filterCaregivers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCaregivers = _allCaregivers;
      });
    } else {
      setState(() {
        _filteredCaregivers = _allCaregivers
            .where((caregiver) =>
                caregiver.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
            child: ListView.builder(
              itemCount: _filteredCaregivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCaregivers[index]),
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
