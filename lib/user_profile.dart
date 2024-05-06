//log-in app
import 'package:alzheimer_app1/carer_form.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';
import 'package:http/http.dart' as http;

import 'models/log_in.dart';

final usuariosService = UsuariosService();
final tokenUtils = TokenUtils();
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  static const Color dividerColor = Colors.black;

  /*void _showUserform(BuildContext context){
    Navigator.of(context).pushNamed(routeName);
  }*/
  Future<void> _showDialog(BuildContext context,Usuarios usuario){
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
                              builder: (context) => CarerForm(usuario:usuario),
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

  Widget _buildContent(BuildContext context,AsyncSnapshot<String> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting)
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Perfil de Usuario'),
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else if(snapshot.hasError)
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Perfil de Usuario'),
        ),
        body: Center(
          child: Text('Error al obtener el token: ${snapshot.error}'),
        ),
      );
    }else{
      return FutureBuilder<Usuarios>(
        future:usuariosService.obtenerUsuarioPorId(snapshot.data!),
        builder: (context,usuarioSnapshot){
          if(usuarioSnapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Datos de Usuario'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else if(usuarioSnapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Datos de Usuario'),
              ),
              body: Center(
                child: Text('Error al obtener el usuario: ${usuarioSnapshot.error}'),
              ),
            );
          }else{
            final usuario = usuarioSnapshot.data!;
            return _buildUserProfile(context, usuario);
          }
        },
      );
    }
  }

  Widget _buildUserProfile(BuildContext context, Usuarios usuario){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Perfil de Usuario')),
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
                    usuario.idPersona!.nombre,
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 20),

                  //Icons
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.person_outline_rounded,
                      text: '${usuario.idPersona!.nombre} ${usuario.idPersona!.apellidoP} ${usuario.idPersona!.apellidoM} ',
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.phone_iphone_outlined,
                      text: usuario.idPersona!.numeroTelefono!,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.email_outlined,
                      text: usuario.correo,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.date_range,
                      text: usuario.idPersona!.fechaNacimiento.toString().split(' ')[0],
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      _showDialog(context,usuario);
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
      builder: _buildContent,
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
