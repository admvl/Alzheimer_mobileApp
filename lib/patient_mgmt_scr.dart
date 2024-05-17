import 'package:flutter/material.dart';

/*
void main() {
  runApp(const MaterialApp(
    home: PatientManagementScreen(),
  ));
}*/

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  _PatientManagementScreenState createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Gestión de Pacientes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Familiares'),
              Tab(text: 'Cuidadores'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FamiliaresTab(),
            CuidadoresTab(),
          ],
        ),
      ),
    );
  }
}

class FamiliaresTab extends StatelessWidget {
  const FamiliaresTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuscadorScreen()),
              );
            },
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Aquí debes poner la cantidad real de familiares
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Familiar ${index + 1}'),
                subtitle: Text('Detalle del Familiar ${index + 1}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CuidadoresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuscadorCuidadoresScreen()),
              );
            },
            child: Text('+ADD'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Aquí debes poner la cantidad real de cuidadores
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Cuidador ${index + 1}'),
                subtitle: Text('Detalle del Cuidador ${index + 1}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BuscadorScreen extends StatelessWidget {
  const BuscadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador'),
      ),
      body: const Center(
        child: Text('Pantalla de búsqueda de familiares'),
      ),
    );
  }
}

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
}
