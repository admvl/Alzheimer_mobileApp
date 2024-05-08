import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:flutter/material.dart';


final dispositivoService = DispositivosService();

class ConfigureGeocerca extends StatelessWidget{
  const ConfigureGeocerca({super.key});

  Widget _buildContent (BuildContext context, AsyncSnapshot<String> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting)
    {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if(snapshot.hasError){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al configurar geocerca'),
        ),
      );
    } else{
      return FutureBuilder(
          future: dispositivoService.obtenerDispositivoPorId(id),
          builder: (context, dispositivoSnapshot){
            if(dispositivoSnapshot.connectionState == ConnectionState.waiting){
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
      );
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Dispositivos>(
    future: dispositivoService.obtenerDispositivoPorId(dispositivoId!),
    builder: (context, geocercaSnapshot){
      if(geocercaSnapshot.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if(geocercaSnapshot.hasError){
        return Center(
          child: Text('Error al obtener la zona segura: ${geocercaSnapshot.error}'),
        );
      } else {
        final geocerca = geocercaSnapshot.data!;
  }
}