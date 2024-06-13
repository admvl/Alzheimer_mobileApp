import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Acerca de'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Datos del Proyecto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nombre del Proyecto: Prototipo de Sistema de Monitoreo para personas con Alzheimer',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                'No: 2024-A042',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                'Fecha de lanzamiento: Junio 2024',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción del Proyecto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este proyecto consistió en el desarrollo de un prototipo de dispositivo electrónico que sirva de apoyo para el monitoreo de pacientes con Alzheimer a través de la obtención de datos que serán transmitidos a su cuidador mediante una aplicación móvil.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Autores',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Montesinos Pérez Reyna Isabel',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                'Morales Vilchis Ariadne Denisse',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                'Rodríguez Reyes Luis Felipe',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Director',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Dr. José Alfredo Jiménez Benítez',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Imagen del Proyecto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Center(
                child: Image.network(
                  'https://images.unsplash.com/photo-1718253217231-667ee12d5886?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  height: 350,
                  width: 350,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}