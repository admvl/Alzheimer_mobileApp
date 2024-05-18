import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/search_carer_scr.dart';
import 'package:alzheimer_app1/search_family_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/personas_service.dart';
import 'package:flutter/material.dart';

final personaService = PersonasService();
final cuidadoresService = PacientesCuidadoresService();
final pacientesService = PacientesService();

class PatientManagementScreen extends StatefulWidget {
  final Pacientes? paciente;
  const PatientManagementScreen({super.key, this.paciente});

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
            const FamiliaresTab(),
            CuidadoresTab(paciente: widget.paciente),
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
                MaterialPageRoute(builder: (context) => const BuscadorFamiliaresScreen()),
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


/*
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
}*/

/*
class CuidadoresTab extends StatelessWidget {
  final String pacienteId;

  CuidadoresTab({required this.pacienteId});

  Future<List<Personas>> obtenerDetallesCuidadores(List<PacientesCuidadores> cuidadores) async {
    List<Future<Personas>> futures = cuidadores.map((cuidador) => personaService.obtenerPersonaPorId(cuidador.idCuidador.idUsuario.idPersona!.nombre)).toList();
    return await Future.wait(futures);
  }

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
                MaterialPageRoute(builder: (context) => const BuscadorCuidadoresScreen()),
              );
            },
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PacientesCuidadores>>(
            future: cuidadoresService.obtenerCuidadoresPorId(pacienteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay cuidadores disponibles'));
              } else {
                final cuidadores = snapshot.data!;
                return FutureBuilder<List<Personas>>(
                  future: obtenerDetallesCuidadores(cuidadores),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No se pudo obtener los detalles de los cuidadores'));
                    } else {
                      final detallesCuidadores = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesCuidadores.length,
                        itemBuilder: (context, index) {
                          final cuidador = detallesCuidadores[index];
                          return ListTile(
                            title: Text('Cuidador ${cuidador.nombre}'),
                            subtitle: Text('Detalle del Cuidador ${cuidador.detalle}'),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  /*
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
                MaterialPageRoute(builder: (context) => const BuscadorCuidadoresScreen()),
              );
            },
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PacientesCuidadores>>(
            future: obtenerCuidadoresPorId(pacienteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay cuidadores disponibles'));
              } else {
                final cuidadores = snapshot.data!;
                return ListView.builder(
                  itemCount: cuidadores.length,
                  itemBuilder: (context, index) {
                    final cuidador = cuidadores[index];
                    return ListTile(
                      title: Text('Cuidador ${cuidador.}'),
                      subtitle: Text('Detalle del Cuidador ${cuidador.detalle}'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }*/
}*/

class CuidadoresTab extends StatelessWidget {
  final Pacientes? paciente;

  const CuidadoresTab({super.key, required this.paciente});

  // Este método se asegura de obtener los detalles de cada cuidador a partir de la lista de cuidadores
  Future<List<Personas>> obtenerDetallesCuidadores(List<PacientesCuidadores> cuidadores) async {
    List<Future<Personas>> futures = cuidadores.map((cuidador) => personaService.obtenerPersonaPorId(cuidador.idCuidador.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

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
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PacientesCuidadores>>(
            future: cuidadoresService.obtenerCuidadoresPorId(paciente!.idPaciente!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay cuidadores disponibles'));
              } else {
                final cuidadores = snapshot.data!;
                return FutureBuilder<List<Personas>>(
                  future: obtenerDetallesCuidadores(cuidadores),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No se pudo obtener los detalles de los cuidadores'));
                    } else {
                      final detallesCuidadores = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesCuidadores.length,
                        itemBuilder: (context, index) {
                          final cuidador = detallesCuidadores[index];
                          return ListTile(
                            title: Text('Cuidador ${cuidador.nombre}'),
                            subtitle: Text('Detalle del Cuidador ${cuidador.nombre}'),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

