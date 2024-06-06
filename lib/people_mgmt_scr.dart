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
import 'package:alzheimer_app1/user_profile.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final personaService = PersonasService();
final cuidadoresService = PacientesCuidadoresService();
final familiareservice = PacientesFamiliaresService();
final pacientesService = PacientesService();


//Person Management
class PeopleManagementScreen extends StatefulWidget {
  //recibo user
  final Pacientes? paciente;
  final Usuarios? usuario;

  const PeopleManagementScreen({super.key, this.paciente, this.usuario});
  const PeopleManagementScreen.withoutUser({super.key, this.paciente}) : usuario = null;

  @override
  _PeopleManagementScreenState createState() => _PeopleManagementScreenState();
}

class _PeopleManagementScreenState extends State<PeopleManagementScreen> {
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
            FamiliaresTab(paciente: widget.paciente, usuario: widget.usuario),
            CuidadoresTab(paciente: widget.paciente, usuario: widget.usuario),
            PacientesTab(paciente: widget.paciente, usuario: widget.usuario),
          ],
        ),
      ),
    );
  }
}

class FamiliaresTab extends StatelessWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;

  const FamiliaresTab({super.key, this.paciente, this.usuario});
  const FamiliaresTab.withoutUser({super.key, this.paciente}): usuario = null;

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
                MaterialPageRoute(
                  builder: (context) => BuscadorFamiliaresScreen(
                    usuario: usuario,
                    paciente: paciente,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
              ],
            ),
          ),
        ),
        
        Expanded(
          child: FutureBuilder<List<Familiares>>(
            //future: familiareservice.obtenerFamiliaresPorId(),
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
                            leading: const Icon(Icons.person_pin_outlined),
                            title: Text('${familiar.nombre ?? 'Sin detalle disponible'} ${familiar.apellidoP} ${familiar.apellidoM}'),
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
/*
class CuidadoresTab extends StatelessWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;
  const CuidadoresTab({super.key, this.paciente,  this.usuario});
  const CuidadoresTab.withoutUser({super.key, this.paciente}):usuario = null;

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
                MaterialPageRoute(builder: (context) => BuscadorCuidadoresScreen(usuario: usuario, paciente: paciente,)),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
              ],
            ),
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
                            leading: const Icon(Icons.medical_information_outlined),
                            title: Text('${cuidador.nombre ?? 'Sin detalle disponible'} ${cuidador.apellidoP} ${cuidador.apellidoM}'),
                            onTap: () {
                              // Navega a la pantalla de detalles del familiar
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfile()),
                              );
                            },
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
}*/

class CuidadorDetalle {
  final Cuidadores cuidador;
  final Personas persona;

  CuidadorDetalle(this.cuidador, this.persona);
}

class CuidadoresTab extends StatelessWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;
  const CuidadoresTab({super.key, this.paciente, this.usuario});
  const CuidadoresTab.withoutUser({super.key, this.paciente}) : usuario = null;

  Future<List<CuidadorDetalle>> obtenerDetallesCuidadores(List<Cuidadores> cuidadores) async {
    List<Future<CuidadorDetalle>> futures = cuidadores.map((cuidador) async {
      final persona = await personaService.obtenerPersonaPorId(cuidador.idUsuario.idPersona!.idPersona!);
      return CuidadorDetalle(cuidador, persona);
    }).toList();
    return await Future.wait(futures);
  }

  void _removeCuidadorPaciente (Cuidadores? cuidador) async{
    //PacientesCuidadores pacienteCuidador = await cuidadoresService.obtenerPacienteCuidadorPorId(paciente!.idPaciente!);
    PacientesCuidadores pacienteCuidador = await cuidadoresService.obtenerPacienteCuidadorPorId(cuidador!.idUsuario.idUsuario!);
    await cuidadoresService.eliminarPacienteCuidadorPorId(pacienteCuidador.idCuidaPaciente!);
    //_navigateToMedicineForm();
    MaterialPageRoute(
      builder: (context) => const WelcomeScreen(),
    );
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
                MaterialPageRoute(builder: (context) => BuscadorCuidadoresScreen(usuario: usuario, paciente: paciente)),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('ADD'),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Cuidadores>>(
            //future: cuidadoresService.obtenerCuidadoresPorId(paciente!.idPaciente!),
            future: cuidadoresService.obtenerTodo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay cuidadores disponibles'));
              } else {
                final cuidadores = snapshot.data!;
                return FutureBuilder<List<CuidadorDetalle>>(
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
                          final detalle = detallesCuidadores[index];
                          return ListTile(
                            leading: const Icon(Icons.medical_information_outlined),
                            title: Text('${detalle.persona.nombre ?? 'Sin detalle disponible'} ${detalle.persona.apellidoP} ${detalle.persona.apellidoM}'),
                            onTap: () {
                              // Navega a la pantalla de detalles del cuidador
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfile(usuario: detalle.cuidador.idUsuario)),
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeCuidadorPaciente(detalle.cuidador),
                            ),
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

  
/*
  Future<List<PacienteDetalle>> obtenerDetallesPacientes(List<Pacientes> pacientes) async {
    List<Future<PacienteDetalle>> futures = pacientes.map((paciente) async {
      //final persona = await personaService.obtenerPersonaPorId(paciente.idUsuario.idPersona!.idPersona!);
      //final persona = await personaService.obtenerPersonaPorId(paciente.idPersona.idPersona!);
      final persona = paciente.idPersona.nombre
      return PacienteDetalle(paciente, persona);
    }).toList();
    return await Future.wait(futures);
  }*/
  void _removePaciente (Pacientes paciente) async{
    await pacientesService.eliminarPacientePorId(paciente.idPaciente!);
    //_navigateToMedicineForm();
    MaterialPageRoute(
      builder: (context) => const WelcomeScreen(),
    );
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
                MaterialPageRoute(builder: (context) => BuscadorPacientesScreen(usuario: usuario, paciente: paciente,)),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
              ],
            ),
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
                /*return FutureBuilder<List<Pacientes>>(
                  future: obtenerDetallesPacientes(pacientes),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No se pudo obtener los detalles de los pacientes'));
                    } else {
                      final detallesPacientes = snapshot.data!;*/
                      return ListView.builder(
                        itemCount: pacientes.length,
                        itemBuilder: (context, index) {
                          final paciente = pacientes[index];
                          return ListTile(
                            leading: const Icon(Icons.person_3_outlined),
                            //title: Text('${detalle.persona.nombre ?? 'Sin detalle disponible'} ${detalle.persona.apellidoP} ${detalle.persona.apellidoM}'),
                            title: Text('${paciente.idPersona.nombre ?? 'Sin detalle disponible'} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                            onTap: () {
                            /*Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineForm(medicamento: medicamentos[index], paciente: paciente),
                                ),
                              );*/
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removePaciente(paciente),
                            ),
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
                    //}
                  //},
                //);
              }
            },
          ),
        ),
      ],
    );
  }
}