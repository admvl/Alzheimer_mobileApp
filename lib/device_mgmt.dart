import 'package:alzheimer_app1/device_form.dart';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/utils/permission_mixin.dart';
import 'package:flutter/material.dart';

final dispositivosService = DispositivosService();

class DeviceMmgt extends StatefulWidget {
  final Pacientes? paciente;
  //final Usuarios? usuario;
  const DeviceMmgt({super.key, this.paciente});
  //const DeviceMmgt.withoutUser({super.key, this.paciente}) : usuario = null;

  @override
  _DeviceMgmtState createState() => _DeviceMgmtState();
}


class _DeviceMgmtState extends State<DeviceMmgt> with PermissionMixin<DeviceMmgt> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Gestión de Dispositivos'),
      ),
      body: Column(
        children: [
          if (hasPermission("devMgmt"))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceForm(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('ADD'),
                  ],
                ),
              ),
            ),
          Expanded(
            child: _buildDevicesList(context),
          )
        ],
      ),
    );
  }

  Widget _buildDevicesList(BuildContext context) {
    late Future<List<Dispositivos>> dispositivosFuture;
    dispositivosFuture = dispositivosService.obtenerDispositivos();

    return FutureBuilder<List<Dispositivos>>(
      future: dispositivosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay dispositivos disponibles')
          );
        } else {
          final dispositivos = snapshot.data!;
          return ListView.builder(
            itemCount: dispositivos.length,
            itemBuilder: (context, index) {
              final dispositivo = dispositivos[index];
              return ListTile(
                leading: const Icon(Icons.devices),
                title: Text('${dispositivo.idDispositivo}'),
              );
            },
          );
        }
      },
    );
  }
}
