
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/services/dispositivos_service.dart';
import 'package:alzheimer_app1/services/geocercas_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/update_geocerca.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final usuariosService = UsuariosService();
final pacientesService = PacientesService();
final geocercaService = GeocercasService();
final dispositivoService = DispositivosService();
final tokenUtils = TokenUtils();

class PatientSelection extends StatefulWidget {
  const PatientSelection({Key? key}) : super(key: key);

  @override
  _PatientSelectionState createState() => _PatientSelectionState();
}

class _PatientSelectionState extends State<PatientSelection> {
  String? dispositivoPacienteId;
  String? geocercaId;
  late LatLng geofenceCenter = const LatLng(0, 0);
  GoogleMapController? mapController;
  TextEditingController addressController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  Set<Marker> markers = {};
  Circle? geofenceCircle;
  PacientesService _pacientesService = PacientesService();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el ID del usuario
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error al obtener el ID del usuario, muestra un mensaje de error
          return SnackBar(
            content: Text('Error: ${snapshot.error}'),
          );
        }else {
          // Cuando se obtiene el ID del usuario, muestra el diálogo para seleccionar al paciente
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }


  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      // Utiliza un contenedor personalizado en lugar de AlertDialog
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige al paciente:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _pacientesService.obtenerPacientesPorId(idUsuario!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return SnackBar(content: Text('${snapshot.error}'));
                  //return Text('Error: ${snapshot.error}');
                } else {
                  final List<Pacientes> pacientes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return ListTile(
                        title: Text('${paciente.idPersona.nombre} ${paciente.idPersona.apellidoP} ${paciente.idPersona.apellidoM}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateGeocerca(paciente: paciente),
                            ),
                          );
                          //_buildForm;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(paciente.idPersona.nombre),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }



}