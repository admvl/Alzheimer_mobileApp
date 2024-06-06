//log-in app
import 'dart:convert';

import 'package:alzheimer_app1/check_location_scr.dart';
import 'package:alzheimer_app1/models/log_in.dart';
import 'package:alzheimer_app1/services/alzheimer_hub.dart';
import 'package:alzheimer_app1/services/location_provider.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'welcome_scr.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:profile_view/profile_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//void main() => runApp(const LogInpApp());
void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que los widgets estén inicializados
  await AndroidAlarmManager.initialize(); // Inicializa el gestor de alarmas
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> LocationProvider()),
          Provider(create: (_)=> SignalRService())
      ],
      child: const LogInpApp(),
    ),
  ); // Ejecuta la aplicación
}

class LogInpApp extends StatelessWidget {
  const LogInpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const LogInScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 3, 189, 164)),
      ),
    );
  }
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: LogInForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _usuariosService = UsuariosService();
  final _pacientesService = PacientesService();
  late SignalRService _signalRService;
 
  double _formProgress = 0;

  @override
  void initState(){
    super.initState();
    _signalRService = Provider.of<SignalRService>(context,listen: false);
  }
  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  void login() async {
    String usuario = _userNameTextController.text;
    String contrasena = _passwordTextController.text;

    final user = LogIn(correo: usuario, contrasenia: contrasena);
    // Usa UsuariosService para verificar las credenciales
    final response = await _usuariosService.login(user);
    if(!mounted){
      return;
    }
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      final dispositivos = List<String>.from(data['dispositivos']);
      final pacientes = await _pacientesService.obtenerPacientesPorId(await tokenUtils.getIdUsuarioToken());
      for(var item in pacientes){
        if(item.idDispositivo.idDispositivo!=null) {
          await storage.write(
              key: item.idDispositivo.idDispositivo!, value: '${item.idPersona.nombre} ${item.idPersona.apellidoP} ${item.idPersona.apellidoM}');
        }
      }
      if(!mounted)return;
      await _signalRService.initSignalR(context,dispositivos);
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inicio de sesión exitoso"))
      );
      _showWelcomeScreen();
    }else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña incorrecta"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario no encontrado"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress, // NEW
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress), // NEW
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Center(
            child: CircularProfileAvatar(
              '',
              borderColor: Theme.of(context).colorScheme.inversePrimary,
              borderWidth: 2,
              elevation: 5,
              radius: 80,
              child: const ProfileView(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1712945245297-9d9f05cf27b1?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text('Inicio de Sesión',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _userNameTextController,
              decoration: const InputDecoration(hintText: 'Usuario'),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Contraseña'),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Theme.of(context).colorScheme.inverseSurface;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Theme.of(context).colorScheme.primaryContainer;
              }),
            ),
            onPressed: _formProgress == 1 ? login : null, // UPDATED
            child: const Text('Iniciar Sesion'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _userNameTextController,
      _passwordTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
      begin: Theme.of(context).colorScheme.onSecondaryContainer,
      end: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
