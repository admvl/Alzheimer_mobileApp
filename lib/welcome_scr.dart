import 'package:alzheimer_app1/bluetooth_scr.dart';
import 'package:alzheimer_app1/device_conection_scr.dart';
import 'package:alzheimer_app1/medicine_mgmt.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/patient_profile.dart';
import 'package:alzheimer_app1/patient_selection.dart';
import 'package:alzheimer_app1/services/alzheimer_hub.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';
import 'check_location_scr.dart';
import 'fall_alarm_scr.dart';
import 'medicine_alarm_scr.dart';
import 'medicine_form.dart';
import 'register_scr.dart';
import 'set_alarm_scr.dart';
import 'user_mgmt.dart';
import 'user_profile.dart';
import 'zone_alarm_scr.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}



class _WelcomeScreenState extends State<WelcomeScreen>{
  late SignalRService _signalRService;

  @override
  void initState(){
    super.initState();
    _signalRService = Provider.of<SignalRService>(context, listen: false);
  }

  @override
  void dispose(){
    //_signalRService.hubConnection?.stop();
    super.dispose();
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Desea cerrar sesión?'),
          content: const Text('Se cerrará la sesión actual.'),
          actions: [
            TextButton(
              child: const Text('Sí'),
              onPressed: () async {
                await _signalRService.unsubscribeFromDevices();
                await _signalRService.clearStorage(); // Limpiar el almacenamiento
                if(!context.mounted)return;
                Navigator.of(context).pushReplacementNamed('/');
                //Navigator.popUntil(context, ModalRoute.withName('log_in'));
                //const LogInForm();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
      // Navigate to RegisterScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 1:
      // Navigate to RegisterScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 2:
      // Navigate to CheckLocation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserMangement()),
        );
        break;
      /*case 3:
      // Navigate to CheckLocation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicineForm()),
        );
        break;*/
      default:
        debugPrint('Unhandled menu item: $index');
    }
  }


  @override
  Widget build(BuildContext context) {
    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Icon(Icons.person_sharp,
          size: 100, color: Color.fromARGB(255, 3, 189, 164)),
      const Text('Mi Perfil'),
      const Text('Gestionar Usuarios'),
      //const Text('Registro de Medicamentos'),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bienvenido'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _showConfirmationDialog(context); // Llama al diálogo de confirmación
          },
        ),
        actions: [
          // upper bar menu
          StarMenu(
            params: StarMenuParameters.dropdown(context).copyWith(
              backgroundParams: const BackgroundParams().copyWith(
                sigmaX: 3,
                sigmaY: 3,
              ),
            ),
            items: upperMenuItems,
            onItemTapped: (index, c) {
              debugPrint('Item $index tapped');
              c.closeMenu!();
              navigateToScreen(index);
            },
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      /*Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            RegisterScreen registerScreen =
                            const RegisterScreen();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  registerScreen), // Navega a la pantalla RegisterScreen
                            );
                          },
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Gestionar Usuarios'),
                        ),
                      ),*/
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            RegisterScreen registerScreen =
                            const RegisterScreen();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  registerScreen), // Navega a la pantalla RegisterScreen
                            );
                          },
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Usuarios'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            PatientSelection patientSelect = const PatientSelection();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => patientSelect
                              ),
                            );
                          },
                          icon: const Icon(Icons.security),
                          label: const Text('Zona Segura'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            //PatientManagementScreen patientProfileScr = const PatientManagementScreen();
                            PatientProfile patientProfileScr = const PatientProfile();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  patientProfileScr), // Navega a la pantalla RegisterScreen
                            );
                          },
                          icon: const Icon(Icons.person_outline_outlined),
                          label: const Text('Perfil Paciente'),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            CheckLocationScr locationScreen =
                            const CheckLocationScr();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  locationScreen),
                            );
                          },
                          icon: const Icon(Icons.pin_drop_outlined),
                          label: const Text('Ubicación'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            SetAlarmScr setAlarmScr = const SetAlarmScr();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  setAlarmScr), // Navega a la pantalla CheckLocation
                            );
                          },
                          icon: const Icon(Icons.alarm),
                          label: const Text('Alarmas'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            //SetAlarmScr setAlarmScr = const SetAlarmScr();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  MedicineMgmtScreen()), // Navega a la pantalla CheckLocation
                            );
                          },
                          icon: const Icon(Icons.medical_services_outlined),
                          label: const Text('Medicamentos'),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  MedicineAlarmScr medicineAlarmScr = const MedicineAlarmScr();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        medicineAlarmScr), // Navega a la pantalla RegisterScreen
                  );
                },
                icon: const Icon(Icons.alarm),
                label: const Text('Alarma Medicamentos'),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  ZoneAlarmScr zoneAlarmScr = const ZoneAlarmScr();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        zoneAlarmScr), // Navega a la pantalla RegisterScreen
                  );
                },
                icon: const Icon(Icons.crisis_alert_sharp),
                label: const Text('Alarma Zona Segura'),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  FallAlarmScr fallAlarmScr = const FallAlarmScr();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        fallAlarmScr), // Navega a la pantalla RegisterScreen
                  );
                },
                icon: const Icon(Icons.report_problem_outlined),
                label: const Text('Alarma Caída'),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  BluetoothScr bluetoothScr = const BluetoothScr();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        bluetoothScr), // Navega a la pantalla RegisterScreen
                  );
                },
                icon: const Icon(Icons.handyman_outlined),
                label: const Text('Configurar Dispositivo'),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ConnectionStatusPage()), // Navega a la pantalla RegisterScreen
                  );
                },
                icon: const Icon(Icons.wifi_off),
                label: const Text('Alarma Conexión'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
