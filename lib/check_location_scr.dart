//import 'dart:io';
import 'package:flutter/material.dart';

class CheckLocationScr extends StatelessWidget{
  const CheckLocationScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ubicación del paciente'),
      ),
      body: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("HelloWorld!"),
        ],
      ),
    );
  }
}

/*
class PacientResumeInfo extends StatelessWidget {
  const PacientResumeInfo({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold()
  }
}*/
