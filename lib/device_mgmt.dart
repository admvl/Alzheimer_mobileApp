import 'package:alzheimer_app1/bluetooth_scr.dart';
import 'package:alzheimer_app1/device_form.dart';
import 'package:alzheimer_app1/models/dispositivos.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/utils/permission_mixin.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

final dispositivosService = DispositivosService();

class DeviceMmgt extends StatefulWidget {
  final Pacientes? paciente;
  const DeviceMmgt({super.key, this.paciente});

  @override
  _DeviceMgmtState createState() => _DeviceMgmtState();
}

class _DeviceMgmtState extends State<DeviceMmgt> with PermissionMixin<DeviceMmgt> {
  late Future<List<Dispositivos>> dispositivosFuture;

  @override
  void initState() {
    super.initState();
    dispositivosFuture = dispositivosService.obtenerDispositivos();
  }

  void _reloadDevices() {
    setState(() {
      dispositivosFuture = dispositivosService.obtenerDispositivos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gestión de Dispositivos'),
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
                      builder: (context) => const DeviceForm(),
                    ),
                  );
                },
                /*child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('ADD'),
                  ],
                ),*/
                /*
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    if (hasPermission("bluetooth"))
                      ElevatedButton.icon(
                        onPressed: () {
                          BluetoothScr bluetoothScr = const BluetoothScr();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => bluetoothScr),
                          );
                        },
                        icon: const Icon(Icons.handyman_outlined),
                        label: const Text('Configurar Dispositivo'),
                      ),
                  ],
                ),
                */
                child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Text('Añadir Dispositivo'),
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmRemoveDevice(dispositivo.idDispositivo),
                ),
              );
            },
          );
          
        }
      },
    );
  }

  Future<void> _confirmRemoveDevice(String? idDispositivo) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea eliminar este dispositivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      _removeDevice(idDispositivo);
    }
  }

  Future<void> _removeDevice(String? idDispositivo) async {
    try {
      await dispositivosService.eliminarDispositivoPorId(idDispositivo!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo eliminado con éxito')),
      );
      _reloadDevices(); // Recargar la lista de dispositivos
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el dispositivo: $e')),
      );
    }
  }
}
