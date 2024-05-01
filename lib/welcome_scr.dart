import 'package:alzheimer_app1/configure_geocerca_scr.dart';
import 'package:alzheimer_app1/log_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'register_scr.dart';
import 'check_location_scr.dart';
import 'package:star_menu/star_menu.dart';
import 'user_profile.dart';
import 'user_mgmt.dart';
import 'medicine_form.dart';
import 'zone_alarm_scr.dart';
import 'medicine_alarm_scr.dart';
import 'fall_alarm_scr.dart';
import 'set_alarm_scr.dart';


void main() {
  runApp(const MaterialApp(
    home: WelcomeScreen(),
  ));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Icon(Icons.person_sharp,
          size: 100, color: Color.fromARGB(255, 3, 189, 164)),
      const Text('Mi Perfil'),
      const Text('Gestionar Usuarios'),
      const Text('Registro de Medicamentos'),
    ];

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
            MaterialPageRoute(builder: (context) => const UserMgmt()),
          );
          break;
        case 3:
          // Navigate to CheckLocation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicineForm()),
          );
          break;
        default:
          debugPrint('Unhandled menu item: $index');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bienvenido'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                          label: const Text('Nuevo Usuario'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // ... (code for Configurar Zona Segura button)
                            CheckGeocercaScr geocercaScreen =
                                const CheckGeocercaScr();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => geocercaScreen
                              ), // Navega a la pantalla CheckGeocerca
                            );
                          },
                          icon: const Icon(Icons.security),
                          label: const Text('Zona Segura'),
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
                            //CheckLocation locationScreen = const CheckLocation();
                            CheckLocationScr locationScreen =
                                const CheckLocationScr();
                            Navigator.push(
                              context,
                              //MaterialPageRoute(builder: (context) => locationScreen), // Navega a la pantalla CheckLocation
                              MaterialPageRoute(
                                  builder: (context) =>
                                      locationScreen), // Navega a la pantalla CheckLocation
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
                              //MaterialPageRoute(builder: (context) => locationScreen), // Navega a la pantalla CheckLocation
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
                    ],
                  ),
                ],
              ),
            ),
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
                icon: const Icon(Icons.alarm),
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
                icon: const Icon(Icons.alarm),
                label: const Text('Alarma Caída'),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
            onPressed: () {
              //Implementar la acción de cierre de sesión: 
              //Cualquier acción necesaria para cerrar la sesión correctamente

              //Navegar a la pantalla inicial:
              Navigator.popUntil(context, ModalRoute.withName('log_in'));
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

