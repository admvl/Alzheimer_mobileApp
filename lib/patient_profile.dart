//log-in app
/*import 'package:alzheimer_app1/carer_form.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_form.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';
import 'package:http/http.dart' as http;

import 'models/log_in.dart';

//final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final tokenUtils = TokenUtils();
class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});
  static const Color dividerColor = Colors.black;

  /*void _showUserform(BuildContext context){
    Navigator.of(context).pushNamed(routeName);
  }*/
  Future<void> _showDialog(BuildContext context, Pacientes paciente, Usuarios usuario){
    final TextEditingController passwordController = TextEditingController();
    final roundedDecoration = InputDecoration(
      labelText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      fillColor: Colors.blue.withOpacity(0.1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Confirmar contraseña'),
            content: TextFormField(
              controller: passwordController,
              decoration: roundedDecoration.copyWith(labelText: 'Contraseña'),
              obscureText: true,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
              ),
              ElevatedButton(
                  onPressed: (){
                    final user = LogIn(correo:usuario.correo,contrasenia:passwordController.text);
                    usuariosService.login(user).then((http.Response response){
                      if(response.statusCode == 200){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña correcta')),
                        );
                        Navigator.of(context).pop();
                        usuario.contrasenia = passwordController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserForm(paciente:paciente),
                          )
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña incorrecta')),
                        );
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: const Text('Confirmar'),
              )
            ],
          );
        }
    );
  }

  Widget _buildUserProfile(BuildContext context, Pacientes paciente, Usuarios usuario){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Perfil de Paciente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircularProfileAvatar(
                    'hbv,v.jbhb n',
                    borderColor: Theme.of(context).colorScheme.inversePrimary,
                    borderWidth: 2,
                    elevation: 5,
                    radius: 100,
                    child: const ProfileView(
                      image: NetworkImage(
                        //"https://images.unsplash.com/photo-1562788869-4ed32648eb72?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        "https://images.unsplash.com/photo-1566616213894-2d4e1baee5d8?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    //userNickname,
                    paciente.idPersona!.nombre,
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 20),

                  //Icons
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.person_outline_rounded,
                      text: '${paciente.idPersona!.nombre} ${paciente.idPersona!.apellidoP} ${paciente.idPersona!.apellidoM} ',
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.phone_iphone_outlined,
                      text: paciente.idPersona!.numeroTelefono!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  /*const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.email_outlined,
                      text: usuario.correo,
                      dividerColor: dividerColor,
                    ),
                  ),*/
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.date_range,
                      text: paciente.idPersona!.fechaNacimiento.toString().split(' ')[0],
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      _showDialog(context,paciente, usuario);
                    },
                    child: const Text("Editar Información"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el ID del usuario
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error al obtener el ID del usuario, muestra un mensaje de error
          return SnackBar(
            content: Text('Error: ${snapshot.error}'),
          );
        }else {
          // Cuando se obtiene el ID del usuario, muestra el diálogo para seleccionar al paciente
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

    Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      // Utiliza un contenedor personalizado en lugar de AlertDialog
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige al paciente:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: pacientesService.obtenerPacientesPorId(idUsuario!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return SnackBar(content: Text('${snapshot.error}'));
                  //return Text('Error: ${snapshot.error}');
                } else {
                  Usuarios user = getUser(idUsuario);
                  final List<Pacientes> pacientes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return ListTile(
                        title: Text('${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _buildUserProfile(context,paciente, user),
                            ),
                          );
                          //_buildForm;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(paciente.idPersona.nombre),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Usuarios getUser(String? idUsuario) {
    FutureBuilder(
      future: usuariosService.obtenerUsuarioPorId(idUsuario!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return SnackBar(content: Text('${snapshot.error}'));
          //return Text('Error: ${snapshot.error}');
        } else {
          Usuarios user = snapshot.data!;
          return user;
        }
      }
    );
  }

}


class CustomIconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: textColor, fontSize: 18)),
        const SizedBox(width: 10),
      ],
    );
  }
}

class CustomIconPassRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconPassRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: text,
          ),
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    );
  }
}
*/

/*
import 'package:alzheimer_app1/carer_form.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/patient_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_form.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';
import 'package:http/http.dart' as http;

import 'models/log_in.dart';

final pacientesService = PacientesService();
final usuariosService = UsuariosService();
final tokenUtils = TokenUtils();

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});
  static const Color dividerColor = Colors.black;

  Future<void> _showDialog(BuildContext context, Pacientes paciente, Usuarios usuario) {
    final TextEditingController passwordController = TextEditingController();
    final roundedDecoration = InputDecoration(
      labelText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      fillColor: Colors.blue.withOpacity(0.1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar contraseña'),
          content: TextFormField(
            controller: passwordController,
            decoration: roundedDecoration.copyWith(labelText: 'Contraseña'),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final user = LogIn(correo: usuario.correo, contrasenia: passwordController.text);
                usuariosService.login(user).then((http.Response response) {
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña correcta')),
                    );
                    Navigator.of(context).pop();
                    usuario.contrasenia = passwordController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserForm(paciente: paciente),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta')),
                    );
                    Navigator.of(context).pop();
                  }
                });
              },
              child: const Text('Confirmar'),
            )
          ],
        );
      },
    );
  }

  Widget _buildUserProfile(BuildContext context, Pacientes paciente, Usuarios usuario) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Perfil de Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircularProfileAvatar(
                    'hbv,v.jbhb n',
                    borderColor: Theme.of(context).colorScheme.inversePrimary,
                    borderWidth: 2,
                    elevation: 5,
                    radius: 100,
                    child: const ProfileView(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1566616213894-2d4e1baee5d8?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    paciente.idPersona!.nombre,
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.person_outline_rounded,
                      text: '${paciente.idPersona!.nombre} ${paciente.idPersona!.apellidoP} ${paciente.idPersona!.apellidoM}',
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.document_scanner_outlined,
                      text: paciente.idPaciente,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.phone_iphone_outlined,
                      text: paciente.idPersona!.numeroTelefono!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.date_range,
                      text: paciente.idPersona!.fechaNacimiento.toString().split(' ')[0],
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.monitor_heart_outlined,
                      text: paciente.idDispositivo.idDispositivo!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showDialog(context, paciente, usuario);
                    },
                    child: const Text("Editar Información"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PatientManagementScreen()), // Navega a la pantalla
                      );
                    },
                    child: const Text("Gestionar paciente"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return FutureBuilder<Usuarios>(
      future: getUser(idUsuario),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final usuario = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Elige al paciente:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<List<Pacientes>>(
                    future: pacientesService.obtenerPacientesPorId(idUsuario!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Scaffold(
                          body: Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      } else {
                        final List<Pacientes> pacientes = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: pacientes.length,
                          itemBuilder: (context, index) {
                            final paciente = pacientes[index];
                            return ListTile(
                              title: Text(
                                  '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => _buildUserProfile(
                                        context, paciente, usuario),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${paciente.idPersona.nombre} seleccionado'),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Usuarios> getUser(String? idUsuario) async {
    final response = await usuariosService.obtenerUsuarioPorId(idUsuario!);
    return response;
  }
}

class CustomIconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: textColor, fontSize: 18)),
        const SizedBox(width: 10),
      ],
    );
  }
}

class CustomIconPassRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconPassRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: text,
          ),
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    );
  }
}
*/

import 'package:alzheimer_app1/carer_form.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/patient_mgmt_scr.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/user_form.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';
import 'package:http/http.dart' as http;

import 'models/log_in.dart';

final pacientesService = PacientesService();
final usuariosService = UsuariosService();
final tokenUtils = TokenUtils();

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});
  static const Color dividerColor = Colors.black;

  Future<void> _showDialog(BuildContext context, Pacientes paciente, Usuarios usuario, Function onSuccessRedirect) {
    final TextEditingController passwordController = TextEditingController();
    final roundedDecoration = InputDecoration(
      labelText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      fillColor: Colors.blue.withOpacity(0.1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar contraseña'),
          content: TextFormField(
            controller: passwordController,
            decoration: roundedDecoration.copyWith(labelText: 'Contraseña'),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final user = LogIn(correo: usuario.correo, contrasenia: passwordController.text);
                usuariosService.login(user).then((http.Response response) {
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña correcta')),
                    );
                    Navigator.of(context).pop();
                    usuario.contrasenia = passwordController.text;
                    onSuccessRedirect();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta')),
                    );
                    Navigator.of(context).pop();
                  }
                });
              },
              child: const Text('Confirmar'),
            )
          ],
        );
      },
    );
  }

  Widget _buildUserProfile(BuildContext context, Pacientes paciente, Usuarios usuario) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Perfil de Paciente'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircularProfileAvatar(
                    'hbv,v.jbhb n',
                    borderColor: Theme.of(context).colorScheme.inversePrimary,
                    borderWidth: 2,
                    elevation: 5,
                    radius: 100,
                    child: const ProfileView(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1566616213894-2d4e1baee5d8?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    paciente.idPersona!.nombre,
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.person_outline_rounded,
                      text: '${paciente.idPersona!.nombre} ${paciente.idPersona!.apellidoP} ${paciente.idPersona!.apellidoM}',
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.document_scanner_outlined,
                      text: paciente.idPaciente!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.phone_iphone_outlined,
                      text: paciente.idPersona!.numeroTelefono!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.date_range,
                      text: paciente.idPersona!.fechaNacimiento.toString().split(' ')[0],
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.monitor_heart_outlined,
                      text: paciente.idDispositivo.idDispositivo!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showDialog(context, paciente, usuario, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserForm(paciente: paciente)),
                        );
                      });
                    },
                    child: const Text("Editar Información"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showDialog(context, paciente, usuario, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PatientManagementScreen(paciente: paciente)),
                        );
                      });
                    },
                    child: const Text("Gestionar paciente"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return FutureBuilder<Usuarios>(
      future: getUser(idUsuario),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final usuario = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Elige al paciente:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<List<Pacientes>>(
                    future: pacientesService.obtenerPacientesPorId(idUsuario!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Scaffold(
                          body: Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      } else {
                        final List<Pacientes> pacientes = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: pacientes.length,
                          itemBuilder: (context, index) {
                            final paciente = pacientes[index];
                            return ListTile(
                              title: Text(
                                  '${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => _buildUserProfile(
                                        context, paciente, usuario),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${paciente.idPersona.nombre} seleccionado'),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Usuarios> getUser(String? idUsuario) async {
    final response = await usuariosService.obtenerUsuarioPorId(idUsuario!);
    return response;
  }
}

class CustomIconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: textColor, fontSize: 18)),
        const SizedBox(width: 10),
      ],
    );
  }
}

class CustomIconPassRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final Color dividerColor;

  const CustomIconPassRow({
    super.key,
    required this.icon,
    required this.text,
    required this.dividerColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: text,
          ),
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    );
  }
}
