/*
import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final pacieteCuidadoresService = PacientesCuidadoresService();

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
    //final cuidadores = await cuidadoresService.obtenerCuidadoresPorId(paciente.idPaciente!);
    final cuidadores = await cuidadoresService.obtenerTodosCuidadores();
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
*/


import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final pacieteCuidadoresService = PacientesCuidadoresService();
final pacienteCuidadorService = PacientesCuidadoresService();

class BuscadorCuidadoresScreen extends StatefulWidget {
  final Usuarios? usuario;
  final Pacientes? paciente;
  const BuscadorCuidadoresScreen({super.key, this.usuario, this.paciente});
  
  const BuscadorCuidadoresScreen.withoutUsuario({super.key, this.paciente}) : usuario = null;

  @override
  _BuscadorCuidadoresScreenState createState() => _BuscadorCuidadoresScreenState();
}

class _BuscadorCuidadoresScreenState extends State<BuscadorCuidadoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Cuidadores>> _allCuidadoresFuture;
  List<Cuidadores> _filteredCuidadores = [];
  List<Personas> _allCaregivers = [];

  @override
  void initState() {
    super.initState();
    _allCuidadoresFuture = _findCuidadores(widget.paciente);
    _allCuidadoresFuture.then((cuidadores) async {
      List<Personas> caregivers = await obtenerDetallesCuidadores(cuidadores);
      setState(() {
        _allCaregivers = caregivers;
        _filteredCuidadores = cuidadores;
      });
    });
  }

  Future<List<Personas>> obtenerDetallesCuidadores(List<Cuidadores> cuidadores) async {
    List<Future<Personas>> futures = cuidadores.map((cuidador) => personaService.obtenerPersonaPorId(cuidador.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Cuidadores>> _findCuidadores(Pacientes? paciente) async {
    if (paciente == null) return [];
    return await pacienteCuidadorService.obtenerTodosCuidadores();
  }

  void _filterCaregivers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCuidadores = _allCuidadoresFuture as List<Cuidadores>;
      });
    } else {
      List<Cuidadores> filtered = [];
      for (var i = 0; i < _allCaregivers.length; i++) {
        final caregiver = _allCaregivers[i];
        final words = caregiver.nombre!.split(' ') + caregiver.apellidoP.split(' ') + caregiver.apellidoM.split(' ');
        if (words.any((word) => word.toLowerCase().contains(query.toLowerCase()))) {
          filtered.add(_filteredCuidadores[i]);
        }
      }
      setState(() {
        _filteredCuidadores = filtered;
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
                labelText: 'Buscar Cuidadores',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCaregivers,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cuidadores>>(
              future: _allCuidadoresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay cuidadores disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCuidadores.length,
                    itemBuilder: (context, index) {
                      final cuidador = _filteredCuidadores[index];
                      final caregiver = _allCaregivers[index];
                      return ListTile(
                        title: Text('${caregiver.nombre ?? 'Sin detalle disponible'} ${caregiver.apellidoP} ${caregiver.apellidoM}'),
                        onTap: () {
                          _confirmPatientCuidador(widget.paciente!, cuidador);
                        },
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
  
  Future<void> _confirmPatientCuidador(Pacientes paciente, Cuidadores cuidador) async{
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar vinculacion'),
        content: const Text('¿Está seguro de que desea vincular este cuidador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (shouldAdd == true) {
      _addPatientCuidador(paciente, cuidador);
    }
  }
  
  Future<void> _addPatientCuidador(Pacientes paciente, Cuidadores cuidador) async {
    final nuevoPacienteCuidador = PacientesCuidadores(
      idPaciente: paciente.idPaciente!,
      idCuidador: cuidador.idCuidador!, 
    );
    try {
      await pacienteCuidadorService.crearPacienteCuidador(nuevoPacienteCuidador);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuidador vinculado con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeopleManagementScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vincular cuidador: $e')),
      );
    }
  }
  
  
}
