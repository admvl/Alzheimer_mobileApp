//log-in app
import 'package:flutter/material.dart';
import 'welcomeScr.dart';

class MedicineMgmtApp extends StatelessWidget {
  const MedicineMgmtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const MedicineMgmt(),
        '/welcome': (context) => const WelcomeScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 145, 189)),
      ),
    );
  }
}


class MedicineMgmt extends StatelessWidget {
  const MedicineMgmt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: LogInForm(),
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

  double _formProgress = 0;
  void _showWelcomeScreen() {
  Navigator.of(context).pushNamed('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress, // NEW
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //LinearProgressIndicator(value: _formProgress),
          AnimatedProgressIndicator(value: _formProgress), // NEW
          const SizedBox(height: 20),
          Text('Inicio de Sesión', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _userNameTextController,
              decoration: const InputDecoration(hintText: 'Usuario'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Contraseña'),
              obscureText: true,
            ),
          ),
          TextButton(
            style: ButtonStyle(
              
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    //: Theme.of(context).colorScheme.primary;
                    :Theme.of(context).colorScheme.inverseSurface;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Theme.of(context).colorScheme.primaryContainer;
              }),
            ),
            //onPressed: null,
            //onPressed: _showWelcomeScreen,
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null, // UPDATED
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

    // No accedas al contexto aquí
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
      //begin: Theme.of(context).colorScheme.primaryContainer,
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
