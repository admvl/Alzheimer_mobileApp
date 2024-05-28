//log-in app
import 'package:flutter/material.dart';
import 'welcome_scr.dart';

class UserMgmtApp extends StatelessWidget {
  const UserMgmtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const UserMgmt(),
        '/welcome': (context) => const WelcomeScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 3, 145, 189)),
      ),
    );
  }
}

class UserMgmt extends StatelessWidget {
  const UserMgmt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
              //child: LogInForm(),

              ),
        ),
      ),
    );
  }
}

class UserMangement extends StatefulWidget {
  const UserMangement({super.key});

  @override
  State<UserMangement> createState() => _UserMangementState();
}

class _UserMangementState extends State<UserMangement> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gestion de Usuarios'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                
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
