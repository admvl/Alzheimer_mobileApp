//log-in app
import 'package:alzheimer_app1/models/user.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  static const Color dividerColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    /*
    String userNickname = 'User Nickname';
    String userName = "User Name, Last Name";
    String userPhone = "55-55-55-55-55";
    String userEmail = 'User@email.com';
    String userBirthday = "01/01/2001";
    String userPass = "**********";*/
    User user = const User(
        "Name",
        "ApPat",
        "ApMat",
        "userNickname",
        "5512345678",
        "us@email",
        "password",
        "comprobanteFam",
        "fechaNac",
        "picture");
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
                        "https://images.unsplash.com/photo-1562788869-4ed32648eb72?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    //userNickname,
                    user.nombre,
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 20),

                  //Icons
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.person_outline_rounded,
                      text: user.nickname,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.phone_iphone_outlined,
                      text: user.telefono,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.email_outlined,
                      text: user.email,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.date_range,
                      text: user.fechaNac,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomIconRow(
                      icon: Icons.lock_outline,
                      text: user.password,
                      dividerColor: dividerColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

              /*
              child: ListView(
                children: const <Widget> [
                  for(var user in people )
                    ListTile(
                      leading: Image.network(user.picture),
                      title: Text(user.nombre),

                    )
                ],
              ),*/
            ),
          ],
        ),
      ),
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
