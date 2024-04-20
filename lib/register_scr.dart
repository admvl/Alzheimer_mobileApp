import 'package:flutter/material.dart';
import 'carer_form.dart';
import 'user_form.dart';
import 'familiar_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registro de Usuarios'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const UserForm()), // Navega a la pantalla
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
