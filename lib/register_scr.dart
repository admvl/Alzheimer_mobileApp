import 'package:alzheimer_app1/utils/permission_mixin.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'carer_form.dart';
import 'user_form.dart';
import 'familiar_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with PermissionMixin<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registro de Usuarios'),
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            if (hasPermission("carer_form"))
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CarerForm()), // Navega a la pantalla
                  );
                },
                icon: const SizedBox(
                  width: 48,
                  height: 48,
                  //icon: const Icon(Icons.volunteer_activism_outlined),
                  child: Icon(Icons.healing),
                ),
                label: const Text('Cuidador'),
              ),
            const SizedBox(height: 10),
            if (hasPermission("user_form"))
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserForm.withoutPaciente()), // Navega a la pantalla
                  );
                },
                icon: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.person),
                ),
                label: const Text('Paciente'),
              ),
            const SizedBox(height: 10),
            //familiar_form
            if (hasPermission("familiar_form"))
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const FamiliarForm()), // Navega a la pantalla
                  );
                },
                icon: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.group),
                ),
                label: const Text('Familiar'),
              ),
          ],
        ),
      ),
    );
  }
}
