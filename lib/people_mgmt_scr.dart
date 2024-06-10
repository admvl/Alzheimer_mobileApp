import 'package:alzheimer_app1/carer_form.dart' hide usuariosService;
import 'package:alzheimer_app1/familiar_form.dart' hide usuariosService;
import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/familiares.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/pacientes_cuidadores.dart';
import 'package:alzheimer_app1/models/pacientes_familiares.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/search_carer_scr.dart';
import 'package:alzheimer_app1/search_family_scr.dart';
import 'package:alzheimer_app1/search_patient_scr.dart';
import 'package:alzheimer_app1/services/pacientes_cuidadores_service.dart';
import 'package:alzheimer_app1/services/pacientes_familiares_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/personas_service.dart';
import 'package:alzheimer_app1/user_form.dart';
import 'package:alzheimer_app1/user_profile.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:alzheimer_app1/utils/permission_mixin.dart';

final personaService = PersonasService();
final cuidadoresService = PacientesCuidadoresService();
final familiareservice = PacientesFamiliaresService();
final pacientesService = PacientesService();

//Person Management
class PeopleManagementScreen extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;

  const PeopleManagementScreen({super.key, this.paciente, this.usuario});
  const PeopleManagementScreen.withoutUser({super.key, this.paciente}) : usuario = null;
  const PeopleManagementScreen.withoutPatient({super.key, this.usuario}) : paciente = null;
  

  @override
  _PeopleManagementScreenState createState() => _PeopleManagementScreenState();
}

class _PeopleManagementScreenState extends State<PeopleManagementScreen> with PermissionMixin<PeopleManagementScreen>{
  late List<Widget> myTabs;
  late List<Widget> tabViews;
  //
  Usuarios? _usuario;

  @override
  Widget build(BuildContext context) {
    return _usuario == null
      ? FutureBuilder<String>(
          //future: Provider.of<TokenUtils>(context, listen: false).getIdUsuarioToken(),
          future: tokenUtils.getIdUsuarioToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return FutureBuilder<Usuarios>(
                future: usuariosService.obtenerUsuarioPorId(snapshot.data!),
                builder: (context, usuarioSnapshot) {
                  if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (usuarioSnapshot.hasData) {
                    _usuario = usuarioSnapshot.data;
                    setupTabs();  // Set up tabs with the newly fetched user
                    return buildTabs();
                  } else {
                    return Text('Error al obtener usuario: ${usuarioSnapshot.error}');
                  }
                },
              );
            } else {
              return Text('Error al obtener token: ${snapshot.error}');
            }
          },
        )
      : buildTabs();
  }

  Widget buildTabs() {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.paciente != null ? 'Gestión de Pacientes' : 'Gestión de Usuarios'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario; // Start with the given usuario if not null
    setupTabs();
  }

  void setupTabs() {
    if (widget.paciente == null) {
      myTabs = [
        if (hasPermission("familyTab"))
          const Tab(text: 'Familiares'),

        if (hasPermission("carerTab"))
          const Tab(text: 'Cuidadores'),

        const Tab(text: 'Pacientes'),
      ];
      tabViews = [
        if (hasPermission("familyTab"))
          FamiliaresTab(paciente: widget.paciente, usuario: _usuario),

        if (hasPermission("carerTab"))
          CuidadoresTab(paciente: widget.paciente, usuario: _usuario),

        PacientesTab(paciente: widget.paciente, usuario: _usuario),
      ];
    } else if (widget.paciente != null) {
      myTabs = [
        //if (hasPermission("familyTab"))
          const Tab(text: 'Familiares'),
        
        //if (hasPermission("carerTab"))
          const Tab(text: 'Cuidadores'),
      ];
      tabViews = [
        //if (hasPermission("familyTab"))
          FamiliaresTab(paciente: widget.paciente, usuario: _usuario),

        //if (hasPermission("carerTab"))
          CuidadoresTab(paciente: widget.paciente, usuario: _usuario),
      ];
    }
  }
}



//Cuidador no tiene acceso
//class FamiliaresTab extends StatelessWidget {
class FamiliaresTab extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;

  const FamiliaresTab({super.key, this.paciente, this.usuario});
  const FamiliaresTab.withoutPatient({super.key, this.usuario}) : paciente = null;
  const FamiliaresTab.withoutUser({super.key, this.paciente}) : usuario = null;

  @override
  _FamiliaresTabState createState() => _FamiliaresTabState();
}

class _FamiliaresTabState extends State<FamiliaresTab> with PermissionMixin<FamiliaresTab> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasPermission("addFam"))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => BuscadorFamiliaresScreen(usuario: usuario, paciente: paciente),
                    //builder: (context) => const FamiliarForm(),

                    builder: (context) => widget.paciente == null 
                      ? const FamiliarForm()
                      : BuscadorFamiliaresScreen(usuario: widget.usuario, paciente: widget.paciente),
                  ),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Añadir Familiar'),
                ],
              ),
            ),
          ),
        Expanded(
          child: _buildFamiliaresList(context),
        ),
      ],
    );
  }

  Widget _buildFamiliaresList(BuildContext context) {

    late Future<List<Familiares>> familiaresFuture;
    if(widget.usuario!.idTipoUsuario!.tipoUsuario == "Administrador"){
      if(widget.paciente!= null){
        //solo familiares asignados al paciente actual
        familiaresFuture = familiareservice.obtenerFamiliaresPorId(widget.paciente!.idPaciente!); //ok
      }else{
       //muestra a todos los familiares para gestión de usuario
       familiaresFuture = familiareservice.obtenerTodosFamiliares();  
      }
    } else if (widget.usuario!.idTipoUsuario!.tipoUsuario == "Familiar" ){ // cuidador no tiene acceso
       familiaresFuture = familiareservice.obtenerFamiliaresPorId(widget.paciente!.idPaciente!);
    }

    return FutureBuilder<List<Familiares>>(
      future: familiaresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay familiares disponibles'));
        } else {
          final familiares = snapshot.data!;
          return ListView.builder(
            itemCount: familiares.length,
            itemBuilder: (context, index) {
              final familiar = familiares[index];
              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('${familiar.idUsuario.idPersona!.nombre} ${familiar.idUsuario.idPersona!.apellidoP} ${familiar.idUsuario.idPersona!.apellidoM}'),
                onTap: () {
                  // Navega a la pantalla de detalles del cuidador
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile(usuario: familiar.idUsuario)),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmRemovePatientFamiliar(widget.paciente!, familiar),
                ),
              );
            },
          );
        }
      },
    );
  }
  _confirmRemovePatientFamiliar(Pacientes paciente, Familiares familiar) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea desvincular este familiar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try{
        PacientesFamiliares relacionPatientFam = await familiareservice.obtenerPacienteFamiliarPorId(paciente.idPaciente!);
        /*for (var relacion in relacionPatientFam) {
          if(relacion.idPaciente.idPaciente == paciente.idPaciente && relacion.idFamiliar.idFamiliar == familiar.idFamiliar){
            _removePatientFamiliar(relacion.idPacienteFamiliar!);
          }
        } */
        _removePatientFamiliar(relacionPatientFam.idPacienteFamiliar!);
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener relación paciente - familiar: $e')),
        );
      }
    }
  }
  
  Future<void> _removePatientFamiliar(String idRelacion) async{
    try {
      await familiareservice.eliminarPacienteFamiliarPorId(idRelacion);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El familiar a sido desvinculado con éxito')),
      );
      //_reloadDevices(); // Recargar la lista de dispositivos
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al desvincular el familiar: $e')),
      );
    }
  }
}


class CuidadoresTab extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;

  const CuidadoresTab({Key? key, this.paciente, this.usuario}) : super(key: key);
  const CuidadoresTab.withoutPatient({Key? key, this.usuario}) : paciente = null;
  const CuidadoresTab.withoutUser({Key? key, this.paciente}) : usuario = null;

  @override
  _CuidadoresTabState createState() => _CuidadoresTabState();
}

class _CuidadoresTabState extends State<CuidadoresTab> with PermissionMixin<CuidadoresTab> {

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
                    builder: (context) => widget.paciente == null 
                      ? const CarerForm()
                      : BuscadorCuidadoresScreen(usuario: widget.usuario, paciente: widget.paciente),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Añadir Cuidador'),
              ],
            ),
          ),
        ),
        Expanded(
          child: _buildCuidadoresList(context),
        ),
      ],
    );
  }

  Widget _buildCuidadoresList (BuildContext context){

    late Future<List<Cuidadores>> cuidadoresFuture;
    if(widget.usuario!.idTipoUsuario!.tipoUsuario == "Administrador"){
      if(widget.paciente!= null){
        //solo cuidadores asignados al paciente actual
        cuidadoresFuture = cuidadoresService.obtenerCuidadoresPorId(widget.paciente!.idPaciente!);  
      } else{
        //obtiene todos los cuidadores para gestionar usuarios
       cuidadoresFuture = cuidadoresService.obtenerTodosCuidadores();  
      }
    }else if (widget.usuario!.idTipoUsuario!.tipoUsuario == "Familiar"){ //cuidador no tiene acceso
      cuidadoresFuture = cuidadoresService.obtenerCuidadoresPorId(widget.paciente!.idPaciente!);  
    }

    return FutureBuilder<List<Cuidadores>>(
      //future: cuidadoresService.obtenerTodo(),
      future: cuidadoresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No hay cuidadores disponibles'));
        } else {
          final cuidadores = snapshot.data!;
          return ListView.builder(
            itemCount: cuidadores.length,
            itemBuilder: (context, index) {
              final cuidador = cuidadores[index];
              return ListTile(
                leading: const Icon(Icons.medical_information_outlined),
                title: Text(
                    '${cuidador.idUsuario.idPersona!.nombre ?? 'Sin detalle disponible'} ${cuidador.idUsuario.idPersona!.apellidoP} ${cuidador.idUsuario.idPersona!.apellidoM}'),
                onTap: () {
                  // Navega a la pantalla de detalles del cuidador
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile(usuario: cuidador.idUsuario)),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmRemoveCuidadorFamiliar(widget.paciente!, cuidador),
                ),
              );
            },
          );
        }
      },
    );
  }

  _confirmRemoveCuidadorFamiliar(Pacientes paciente, Cuidadores cuidador) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea desvincular este cuidador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try{
        PacientesCuidadores relacionPatientCarer = await cuidadoresService.obtenerPacienteCuidadorPorId(paciente.idPaciente!);
        _removePatientCuidador(relacionPatientCarer.idCuidaPaciente!);
      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener relación paciente - cuidador: $e')),
        );
      }
    }
  }
  
  Future<void> _removePatientCuidador(String idRelacion) async{
    try {
      await cuidadoresService.eliminarPacienteCuidadorPorId(idRelacion);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El cuidador a sido desvinculado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al desvincular el cuidador: $e')),
      );
    }
  }
}




class PacientesTab extends StatefulWidget {
  final Pacientes? paciente;
  final Usuarios? usuario;
  const PacientesTab({super.key, this.paciente, this.usuario});
  const PacientesTab.withoutUser({super.key, this.paciente}) : usuario = null;

  @override
  _PacientesTabState createState() => _PacientesTabState();
}


class _PacientesTabState extends State<PacientesTab>  with PermissionMixin<PacientesTab>{
//class PacientesTab extends StatelessWidget with PermissionMixin<PacientesTab>{
  void _removePaciente(Pacientes paciente) async {
    await pacientesService.eliminarPacientePorId(paciente.idPaciente!);
    MaterialPageRoute(
      builder: (context) => const WelcomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasPermission("addPac"))
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //builder: (context) => BuscadorFamiliaresScreen(usuario: usuario, paciente: paciente),
                  builder: (context) => const UserForm(),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Añadir Paciente'),
              ],
            ),
          ),
        ),
        Expanded(
          child: _buildPacientesList(context),
        )
      ],
    );
  }


  Widget _buildPacientesList(BuildContext context){

    late Future<List<Pacientes>> pacientesFuture;
    if(widget.usuario!.idTipoUsuario!.tipoUsuario == "Administrador"){
       pacientesFuture = pacientesService.obtenerTodosPacientes();  
    } else if (widget.usuario!.idTipoUsuario!.tipoUsuario == "Familiar" || widget.usuario!.idTipoUsuario!.tipoUsuario == "Cuidador"){
      pacientesFuture = pacientesService.obtenerPacientesPorId(widget.usuario!.idUsuario!);  
    }

    return FutureBuilder<List<Pacientes>>(
      //future: pacientesService.obtenerPacientesPorId(usuario!.idUsuario!),
      future: pacientesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No hay pacientes disponibles'));
        } else {
          final pacientes = snapshot.data!;
          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index];
              return ListTile(
                leading: const Icon(Icons.person_3_outlined),
                title: Text(
                    '${paciente.idPersona.nombre ?? 'Sin detalle disponible'} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
//                if (hasPermission("patientTab"))
                //patientTab
                /*trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removePaciente(paciente),
                ),*/
                trailing: hasPermission("patientTab")
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removePaciente(paciente),
                    )
                  : null,
              );
            },
          );
        }
      },
    );
  }
}
