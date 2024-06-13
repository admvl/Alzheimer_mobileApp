import 'package:flutter/material.dart';
import 'package:alzheimer_app1/models/notificaciones.dart';
import 'package:alzheimer_app1/services/notificaciones_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';

class NotificacionesScreen extends StatefulWidget {
  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late Future<List<Notificaciones>> _futureNotificaciones;
  String? usuario;

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    usuario = await TokenUtils().getIdUsuarioToken();
    setState(() {
      _futureNotificaciones = NotificacionesService().obtenerNotificaciones(usuario!);
    });
  }

  Icon _getIconForNotificationType(String idTipoNotificacion) {
    idTipoNotificacion = idTipoNotificacion.toUpperCase();
    switch (idTipoNotificacion) {
      case 'F08E572E-1ED7-4006-B769-3B39B9364D16':
        return Icon(Icons.report_problem, color: Colors.red);
      case '1C54A3D4-0136-4AE9-AC44-51151254C734':
        return Icon(Icons.location_off, color: Colors.orange);
      case '41706CF7-E7EB-45ED-AF7A-7637EE86D499':
        return Icon(Icons.wifi_off, color: Colors.blue);
      default:
        return Icon(Icons.notifications, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Notificaciones'),
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
      body: usuario == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Notificaciones>>(
        future: _futureNotificaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay notificaciones.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notificacion = snapshot.data![index];
                return ListTile(
                  leading: _getIconForNotificationType(notificacion.idTipoNotificacion),
                  title: Text(notificacion.mensaje),
                  subtitle: Text(
                    '${notificacion.fecha?.toLocal().toString().split(' ')[0]} ${notificacion.hora.format(context)}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
