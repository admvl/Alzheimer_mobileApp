import 'package:flutter/material.dart';

class BuscadorFamiliaresScreen extends StatelessWidget {
  const BuscadorFamiliaresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador'),
      ),
      body: const Center(
        child: Text('Pantalla de búsqueda de familiares'),
      ),
    );
  }
}