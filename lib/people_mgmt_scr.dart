import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/personas.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/search_carer_scr.dart';
import 'package:alzheimer_app1/search_family_scr.dart';
import 'package:alzheimer_app1/search_patient_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:alzheimer_app1/services/pacientes_familiares_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/personas_service.dart';
import 'package:flutter/material.dart';

final personaService = PersonasService();
final cuidadoresService = PacientesCuidadoresService();
final familiareservice = PacientesFamiliaresService();
final pacientesService = PacientesService();


//Person Management
class PatientManagementScreen extends StatefulWidget {
  //recibo user
  final Pacientes? paciente;
  final Usuarios? usuario;

  const PatientManagementScreen({super.key, this.paciente, this.usuario});
  const PatientManagementScreen.withoutUser({super.key, this.paciente}) : usuario = null;

  @override
  _PatientManagementScreenState createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Gestión de Pacientes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Familiares'),
              Tab(text: 'Cuidadores'),
              Tab(text: 'Pacientes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FamiliaresTab(paciente: widget.paciente),
            CuidadoresTab(paciente: widget.paciente),
            PacientesTab(paciente: widget.paciente, usuario: widget.usuario),
          ],
        ),
      ),
    );
  }
}

class FamiliaresTab extends StatelessWidget {
  final Pacientes? paciente;
  const FamiliaresTab({super.key, this.paciente});

  Future<List<Personas>> obtenerDetallesFamiliares(List<Familiares> familiares) async {
    List<Future<Personas>> futures = familiares.map((familiar) => personaService.obtenerPersonaPorId(familiar.idUsuario.idPersona!.idPersona!)).toList();

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
                MaterialPageRoute(builder: (context) => BuscadorFamiliaresScreen()),
              );
            },
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Familiares>>(
            future: familiareservice.obtenerFamiliaresPorId(paciente!.idPaciente!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay familiares disponibles'));
              } else {
                final familiares = snapshot.data!;
                return FutureBuilder<List<Personas>>(
                  future: obtenerDetallesFamiliares(familiares),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No se pudo obtener los detalles de los familiares'));
                    } else {
                      final detallesFamiliares = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesFamiliares.length,
                        itemBuilder: (context, index) {
                          final familiar = detallesFamiliares[index];
                          return ListTile(
                            title: Text('Familiar ${index +1 } : ${familiar.nombre ?? 'Sin detalle disponible'} ${familiar.apellidoP} ${familiar.apellidoM}'),
                            /*onTap: () {
                              // Navega a la pantalla de detalles del familiar
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetallePersonaScreen(persona: familiar)),
                              );
                            },*/
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

class CuidadoresTab extends StatelessWidget {
  final Pacientes? paciente;

  const CuidadoresTab({super.key, required this.paciente});
  Future<List<Personas>> obtenerDetallesCuidadores(List<Cuidadores> cuidadores) async {
    List<Future<Personas>> futures = cuidadores.map((cuidador) => personaService.obtenerPersonaPorId(cuidador.idUsuario.idPersona!.idPersona!)).toList();
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
          child: FutureBuilder<List<Cuidadores>>(
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
                            title: Text('Cuidador ${index +1 } : ${cuidador.nombre ?? 'Sin detalle disponible'} ${cuidador.apellidoP} ${cuidador.apellidoM}'),
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

class PacientesTab extends StatelessWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;
  const PacientesTab({super.key, this.paciente, this.usuario});
  const PacientesTab.withoutUser({super.key, this.paciente}): usuario = null;

  Future<List<Personas>> obtenerDetallesPacientes(List<Pacientes> pacientes) async {
    List<Future<Personas>> futures = pacientes.map((paciente) => personaService.obtenerPersonaPorId(paciente.idPersona!.idPersona!)).toList();
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
                MaterialPageRoute(builder: (context) => BuscadorPacientesScreen()),
              );
            },
            child: const Text('+ADD'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Pacientes>>(
            //future: pacientesService.obtenerPacientesPorId(paciente!.idPaciente!),
            future: pacientesService.obtenerPacientesPorId(usuario!.idUsuario!),
            //future: pacientesService.obtenerPacientesPorId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay pacientes disponibles'));
              } else {
                final pacientes = snapshot.data!;
                return FutureBuilder<List<Personas>>(
                  future: obtenerDetallesPacientes(pacientes),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No se pudo obtener los detalles de los pacientes'));
                    } else {
                      final detallesPacientes = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesPacientes.length,
                        itemBuilder: (context, index) {
                          final paciente = detallesPacientes[index];
                          return ListTile(
                            title: Text('Paciente ${index +1 } : ${paciente.nombre ?? 'Sin detalle disponible'} ${paciente.apellidoP} ${paciente.apellidoM}'),
                            /*onTap: () {
                              // Navega a la pantalla de detalles del familiar
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetallePersonaScreen(persona: familiar)),
                              );
                            },*/
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