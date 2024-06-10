/* 1st version
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_familiares_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final pacieteFamiliarService = PacientesFamiliaresService();

class BuscadorFamiliaresScreen extends StatefulWidget {
  final Usuarios? usuario;
  final Pacientes? paciente;
  const BuscadorFamiliaresScreen({super.key, this.usuario, this.paciente});
  
  const BuscadorFamiliaresScreen.withoutUsuario({super.key, this.paciente}) : usuario = null;

  @override
  _BuscadorFamiliaresScreenState createState() => _BuscadorFamiliaresScreenState();
}

class _BuscadorFamiliaresScreenState extends State<BuscadorFamiliaresScreen> {
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

  Future<List<Personas>> obtenerDetallesFamiliares(List<Familiares> familiares) async {
    List<Future<Personas>> futures = familiares.map((familiar) => personaService.obtenerPersonaPorId(familiar.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Personas>> _findCaregivers(Pacientes? paciente) async {
    if (paciente == null) return [];
    //cambiar para obtener todos los familiares existentes
    //final familiares = await familiareservice.obtenerFamiliaresPorId(paciente.idPaciente!);
    final familiares = await familiareservice.obtenerTodosFamiliares();
    if (familiares.isEmpty) return [];
    return await obtenerDetallesFamiliares(familiares);
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
        title: const Text('Buscador - Familiares'),
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
                labelText: 'Buscar familiares',
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
                  return const Center(child: Text('No hay familiares disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCaregivers.length,
                    itemBuilder: (context, index) {
                      final familiar = _filteredCaregivers[index];
                      Familiares fam = _allCaregivers[index];
                      return ListTile(
                        title: Text('${familiar.nombre ?? 'Sin detalle disponible'} ${familiar.apellidoP} ${familiar.apellidoM}'),
                        onTap: () {
                          // Navega a la cuadro de dialogo para confirmar vinculación paciente - familiar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => _confirmPatientFamiliar(widget.paciente, fam)),
                          );
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
  
  Future<void> _confirmPatientFamiliar(Pacientes paciente, Personas familiar) async{
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar vinculacion'),
        content: const Text('¿Está seguro de que desea vincular este familiar?'),
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
      _addPatientFamiliar(paciente, familiar);
    }
  }
  
  Future<void> _addPatientFamiliar(Pacientes paciente, Personas familiar) async {
    final nuevoPacienteFamiliar = PacientesFamiliares(
      idPaciente: paciente, 
      idFamiliar: familiar.
    );
    try{
      await pacieteFamiliarService.crearPacienteFamiliar(nuevoPacienteFamiliar);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo registrado con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeopleManagementScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vincular familiar: $e')),
      );
    }
  }
}
*/

/* second version chat
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_familiares_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final pacieteFamiliarService = PacientesFamiliaresService();

class BuscadorFamiliaresScreen extends StatefulWidget {
  final Usuarios? usuario;
  final Pacientes? paciente;
  const BuscadorFamiliaresScreen({super.key, this.usuario, this.paciente});
  
  const BuscadorFamiliaresScreen.withoutUsuario({super.key, this.paciente}) : usuario = null;

  @override
  _BuscadorFamiliaresScreenState createState() => _BuscadorFamiliaresScreenState();
}

class _BuscadorFamiliaresScreenState extends State<BuscadorFamiliaresScreen> {
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

  Future<List<Personas>> obtenerDetallesFamiliares(List<Familiares> familiares) async {
    List<Future<Personas>> futures = familiares.map((familiar) => personaService.obtenerPersonaPorId(familiar.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Personas>> _findCaregivers(Pacientes? paciente) async {
    if (paciente == null) return [];
    final familiares = await familiareservice.obtenerTodosFamiliares();
    if (familiares.isEmpty) return [];
    return await obtenerDetallesFamiliares(familiares);
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
        title: const Text('Buscador - Familiares'),
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
                labelText: 'Buscar familiares',
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
                  return const Center(child: Text('No hay familiares disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredCaregivers.length,
                    itemBuilder: (context, index) {
                      final familiar = _filteredCaregivers[index];
                      return ListTile(
                        title: Text('${familiar.nombre ?? 'Sin detalle disponible'} ${familiar.apellidoP} ${familiar.apellidoM}'),
                        onTap: () {
                          _confirmPatientFamiliar(widget.paciente!, familiar);
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
  
  Future<void> _confirmPatientFamiliar(Pacientes paciente, Personas familiar) async{
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar vinculacion'),
        content: const Text('¿Está seguro de que desea vincular este familiar?'),
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
      _addPatientFamiliar(paciente, familiar);
    }
  }
  
  Future<void> _addPatientFamiliar(Pacientes paciente, Personas familiar) async {
    final nuevoPacienteFamiliar = PacientesFamiliares(
      idPaciente: paciente,
      idFamiliar: familiar.idPersona, // Aquí es donde corriges el error de sintaxis
    );
    try {
      await pacieteFamiliarService.crearPacienteFamiliar(nuevoPacienteFamiliar);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Familiar vinculado con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeopleManagementScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vincular familiar: $e')),
      );
    }
  }
}
*/

import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_familiares_service.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final pacieteFamiliarService = PacientesFamiliaresService();

class BuscadorFamiliaresScreen extends StatefulWidget {
  final Usuarios? usuario;
  final Pacientes? paciente;
  const BuscadorFamiliaresScreen({super.key, this.usuario, this.paciente});
  
  const BuscadorFamiliaresScreen.withoutUsuario({super.key, this.paciente}) : usuario = null;

  @override
  _BuscadorFamiliaresScreenState createState() => _BuscadorFamiliaresScreenState();
}

class _BuscadorFamiliaresScreenState extends State<BuscadorFamiliaresScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Familiares>> _allFamiliaresFuture;
  List<Familiares> _filteredFamiliares = [];
  List<Personas> _allCaregivers = [];

  @override
  void initState() {
    super.initState();
    _allFamiliaresFuture = _findFamiliares(widget.paciente);
    _allFamiliaresFuture.then((familiares) async {
      List<Personas> caregivers = await obtenerDetallesFamiliares(familiares);
      setState(() {
        _allCaregivers = caregivers;
        _filteredFamiliares = familiares;
      });
    });
  }

  Future<List<Personas>> obtenerDetallesFamiliares(List<Familiares> familiares) async {
    List<Future<Personas>> futures = familiares.map((familiar) => personaService.obtenerPersonaPorId(familiar.idUsuario.idPersona!.idPersona!)).toList();
    return await Future.wait(futures);
  }

  Future<List<Familiares>> _findFamiliares(Pacientes? paciente) async {
    if (paciente == null) return [];
    return await familiareservice.obtenerTodosFamiliares();
  }

  void _filterCaregivers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFamiliares = _allFamiliaresFuture as List<Familiares>;
      });
    } else {
      List<Familiares> filtered = [];
      for (var i = 0; i < _allCaregivers.length; i++) {
        final caregiver = _allCaregivers[i];
        final words = caregiver.nombre!.split(' ') + caregiver.apellidoP.split(' ') + caregiver.apellidoM.split(' ');
        if (words.any((word) => word.toLowerCase().contains(query.toLowerCase()))) {
          filtered.add(_filteredFamiliares[i]);
        }
      }
      setState(() {
        _filteredFamiliares = filtered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Buscador - Familiares'),
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
                labelText: 'Buscar familiares',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCaregivers,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Familiares>>(
              future: _allFamiliaresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay familiares disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredFamiliares.length,
                    itemBuilder: (context, index) {
                      final familiar = _filteredFamiliares[index];
                      final caregiver = _allCaregivers[index];
                      return ListTile(
                        title: Text('${caregiver.nombre ?? 'Sin detalle disponible'} ${caregiver.apellidoP} ${caregiver.apellidoM}'),
                        onTap: () {
                          _confirmPatientFamiliar(widget.paciente!, familiar);
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
  
  Future<void> _confirmPatientFamiliar(Pacientes paciente, Familiares familiar) async{
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar vinculacion'),
        content: const Text('¿Está seguro de que desea vincular este familiar?'),
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
      _addPatientFamiliar(paciente, familiar);
    }
  }
  
  Future<void> _addPatientFamiliar(Pacientes paciente, Familiares familiar) async {
    final nuevoPacienteFamiliar = PacientesFamiliares(
      idPaciente: paciente.idPaciente!,
      idFamiliar: familiar.idFamiliar!, // Aquí aseguramos que idFamiliar es del tipo correcto
    );
    try {
      await pacieteFamiliarService.crearPacienteFamiliar(nuevoPacienteFamiliar);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Familiar vinculado con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeopleManagementScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vincular familiar: $e')),
      );
    }
  }
  
  
}
