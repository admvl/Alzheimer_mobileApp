/* OK
import 'package:alzheimer_app1/bluetooth_scr.dart';
import 'package:alzheimer_app1/device_conection_scr.dart';
import 'package:alzheimer_app1/device_mgmt.dart';
import 'package:alzheimer_app1/medicine_mgmt.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/notification_src.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/patient_profile.dart';
import 'package:alzheimer_app1/patient_selection.dart';
import 'package:alzheimer_app1/services/alzheimer_hub.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
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
import 'widgets/permission_widget.dart';
import 'package:alzheimer_app1/utils/permission_mixin.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with PermissionMixin<WelcomeScreen> {
  late SignalRService _signalRService;

  @override
  void initState() {
    super.initState();
    _signalRService = Provider.of<SignalRService>(context, listen: false);
  }

  @override
  void dispose() {
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
                if (!context.mounted) return;
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
      // Navigate to UserProfile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 1:
      // Navigate to UserProfile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 2:
      // Navigate to PeopleManagementScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PeopleManagementScreen.withoutUser()),
        );
        break;
      default:
        debugPrint('Unhandled menu item: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Icon(Icons.person_sharp, size: 100, color: Color.fromARGB(255, 3, 189, 164)),
      const Text('Mi Perfil'),
      const Text('Gestionar Usuarios'),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false; // This will disable the back button
      },
      child: Scaffold(
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
            children: [
              const SizedBox(height: 10),
              if (hasPermission("zoneScr"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      PatientSelection patientSelect = const PatientSelection();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => patientSelect),
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
                    PatientProfile patientProfileScr = const PatientProfile();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => patientProfileScr),
                    );
                  },
                  icon: const Icon(Icons.person_outline_outlined),
                  label: const Text('Perfil Paciente'),
                ),
              ),
              const SizedBox(height: 20),
              if (hasPermission("location"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      CheckLocationScr locationScreen = const CheckLocationScr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => locationScreen),
                      );
                    },
                    icon: const Icon(Icons.pin_drop_outlined),
                    label: const Text('Ubicación'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("setMedAlarm"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      SetAlarmScr setAlarmScr = const SetAlarmScr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => setAlarmScr),
                      );
                    },
                    icon: const Icon(Icons.alarm),
                    label: const Text('Alarmas'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("medMgmt"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicineMgmtScreen()),
                      );
                    },
                    icon: const Icon(Icons.medical_services_outlined),
                    label: const Text('Medicamentos'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("medicineAlarm"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      MedicineAlarmScr medicineAlarmScr = const MedicineAlarmScr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => medicineAlarmScr),
                      );
                    },
                    icon: const Icon(Icons.alarm),
                    label: const Text('Alarma Medicamentos'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("zoneAlarm"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ZoneAlarmScr zoneAlarmScr = const ZoneAlarmScr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => zoneAlarmScr),
                      );
                    },
                    icon: const Icon(Icons.crisis_alert_sharp),
                    label: const Text('Alarma Zona Segura'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("fallAlarm"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      FallAlarmScr fallAlarmScr = const FallAlarmScr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => fallAlarmScr),
                      );
                    },
                    icon: const Icon(Icons.report_problem_outlined),
                    label: const Text('Alarma Caída'),
                  ),
                ),
              const SizedBox(height: 10),
              if (hasPermission("bluetooth"))
                Flexible(
                  child: ElevatedButton.icon(
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
                ),
              const SizedBox(height: 10),
              if (hasPermission("devConnAlarm"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ConnectionStatusPage()),
                      );
                    },
                    icon: const Icon(Icons.wifi_off),
                    label: const Text('Alarma Conexión'),
                  ),
                ),
              const SizedBox(height: 10),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeviceMmgt()),
                    );
                  },
                  icon: const Icon(Icons.monitor_heart_outlined),
                  label: const Text('Dispositivos'),
                ),
              ),
              const SizedBox(height: 10),
              //notify
              if (hasPermission("notify"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificacionesScreen()),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                    label: const Text('Historial de Notificaciones'),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:alzheimer_app1/abous_us.dart';
import 'package:alzheimer_app1/bluetooth_scr.dart';
import 'package:alzheimer_app1/device_conection_scr.dart';
import 'package:alzheimer_app1/device_mgmt.dart';
import 'package:alzheimer_app1/medicine_mgmt.dart';
import 'package:alzheimer_app1/models/usuarios.dart';
import 'package:alzheimer_app1/notification_src.dart';
import 'package:alzheimer_app1/people_mgmt_scr.dart';
import 'package:alzheimer_app1/patient_profile.dart';
import 'package:alzheimer_app1/patient_selection.dart';
import 'package:alzheimer_app1/services/alzheimer_hub.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
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
import 'widgets/permission_widget.dart';
import 'package:alzheimer_app1/utils/permission_mixin.dart';
import 'package:star_menu/star_menu.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with PermissionMixin<WelcomeScreen> {
  late SignalRService _signalRService;
  final String imageUrl = "https://plus.unsplash.com/premium_photo-1665203568927-bf0e58ee3d20?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"; // Replace with your actual image URL

  @override
  void initState() {
    super.initState();
    _signalRService = Provider.of<SignalRService>(context, listen: false);
  }

  @override
  void dispose() {
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
                if (!context.mounted) return;
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
      // Navigate to UserProfile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 1:
      // Navigate to UserProfile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificacionesScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsPage()),
        );//AboutUsPage
        break;
      default:
        debugPrint('Unhandled menu item: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Icon(Icons.person_sharp, size: 100, color: Color.fromARGB(255, 3, 189, 164)),
      const Text('Mi Perfil'),
      //const Text('Gestionar Usuarios'),
      const Text('Notificaciones'),
      const Text('Acerca de'),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false; // This will disable the back button
      },
      child: Scaffold(
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
            children: [
              const SizedBox(height: 3),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface, // Color de fondo del tema actual
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: Image.network(
                    'https://plus.unsplash.com/premium_photo-1665203568927-bf0e58ee3d20?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10.0, // Adjust spacing between buttons as needed
                runSpacing: 20.0, // Adjust spacing between rows of buttons as needed
                children: [
                  // Conditionally display buttons based on permissions
                  if (hasPermission("zoneScr"))
                    ElevatedButton.icon(
                      onPressed: () {
                        PatientSelection patientSelect = const PatientSelection();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => patientSelect),
                        );
                      },
                      icon: const Icon(Icons.security),
                      label: const Text('Zona Segura'),
                    ),
                  if (hasPermission("location"))
                    ElevatedButton.icon(
                      onPressed: () {
                        CheckLocationScr locationScreen = const CheckLocationScr();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => locationScreen),
                        );
                      },
                      icon: const Icon(Icons.pin_drop_outlined),
                      label: const Text('Ubicación'),
                    ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  if (hasPermission("setMedAlarm"))
                    ElevatedButton.icon(
                      onPressed: () {
                        SetAlarmScr setAlarmScr = const SetAlarmScr();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => setAlarmScr),
                        );
                      },
                      icon: const Icon(Icons.alarm),
                      label: const Text('Alarmas'),
                    ),
                  if (hasPermission("medMgmt"))
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MedicineMgmtScreen()),
                        );
                      },
                      icon: const Icon(Icons.medical_services_outlined),
                      label: const Text('Medicamentos'),
                    ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        PatientProfile patientProfileScr = const PatientProfile();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => patientProfileScr),
                        );
                      },
                      icon: const Icon(Icons.person_outline_outlined),
                      label: const Text('Perfil Paciente'),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PeopleManagementScreen.withoutUser()),
                      );
                    },
                    icon: const Icon(Icons.people),
                    label: const Text(' Usuarios'),
                  ),

                ],
              ),
              const SizedBox(height: 20),
              if (hasPermission("devMgmt"))
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeviceMmgt()),
                      );
                    },
                    icon: const Icon(Icons.monitor_heart_outlined),
                    label: const Text('Dispositivos'),
                  ),
                ),
              const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}

