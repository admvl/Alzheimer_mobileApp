/* version ok
import 'package:alzheimer_app1/medicine_form.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String name;
  Medicine(this.name);
}

class MedicineMgmtScreen extends StatefulWidget {
  const MedicineMgmtScreen({super.key});

  @override
  _MedicineMgmtScreenState createState() => _MedicineMgmtScreenState();
}

class _MedicineMgmtScreenState extends State<MedicineMgmtScreen> {
  // Sample list of medicines
  List<Medicine> medicines = [];

  // Function to remove medicine
  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  // Function to navigate to MedicineForm screen
  void _navigateToMedicineForm() {
    // Implement navigation to MedicineForm screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineForm()),
    ).then((newMedicine) {
      if (newMedicine != null) {
        setState(() {
          medicines.add(newMedicine);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Medicamentos del Paciente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicines[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeMedicine(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToMedicineForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}


//reemplazado
class MedicineFormScreen extends StatefulWidget {
  const MedicineFormScreen({super.key});

  @override
  _MedicineFormScreenState createState() => _MedicineFormScreenState();
}

class _MedicineFormScreenState extends State<MedicineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _medicineName = '';

  // Function to submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, Medicine(_medicineName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre del Medicamento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _medicineName = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

/* version prueba
import 'package:alzheimer_app1/medicine_form.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String name;
  Medicine(this.name);
}

class MedicineMgmtScreen extends StatefulWidget {
  const MedicineMgmtScreen({super.key});

  @override
  _MedicineMgmtScreenState createState() => _MedicineMgmtScreenState();
}

class _MedicineMgmtScreenState extends State<MedicineMgmtScreen> {
  // Sample list of medicines
  List<Medicine> medicines = [];

  // Function to remove medicine
  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  // Function to navigate to MedicineForm screen
  void _navigateToMedicineForm() {
    // Implement navigation to MedicineForm screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineForm()),
    ).then((newMedicines) {
      if (newMedicines != null && newMedicines is List<Medicine>) {
        setState(() {
          medicines.addAll(newMedicines);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Medicamentos del Paciente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega a la pantalla de bienvenida
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicines[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeMedicine(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToMedicineForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

*/


import 'package:alzheimer_app1/medicine_form.dart';
import 'package:alzheimer_app1/models/medicamentos.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/services/medicamentos_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String name;
  Medicine(this.name);
}

class MedicineMgmtScreen extends StatefulWidget {
  const MedicineMgmtScreen({super.key});

  @override
  _MedicineMgmtScreenState createState() => _MedicineMgmtScreenState();
}

class _MedicineMgmtScreenState extends State<MedicineMgmtScreen> {
  final PacientesService _pacientesService = PacientesService();
  final MedicamentosService _medicamentosService = MedicamentosService();
  final tokenUtils = TokenUtils();
  
  // Sample list of medicines
  List<Medicine> medicines = [];

  // Function to remove medicine
  void _removeMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  // Function to navigate to MedicineForm screen
  void _navigateToMedicineForm() {
    // Implement navigation to MedicineForm screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineForm()),
    ).then((newMedicines) {
      if (newMedicines != null && newMedicines is List<Medicine>) {
        setState(() {
          medicines.addAll(newMedicines);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenUtils.getIdUsuarioToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _buildSelectPatientDialog(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildSelectPatientDialog(BuildContext context, String? idUsuario) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige al paciente al que agregarás medicamentos',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: _pacientesService.obtenerPacientesPorId(idUsuario!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _buildScreen(context, paciente),
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

  //@override
  Widget _buildScreen(BuildContext context, Pacientes paciente) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Medicamentos'),
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
      body: FutureBuilder(
        future: _medicamentosService.obtenerMedicamentosPorId(paciente.idPaciente!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            FloatingActionButton(
              onPressed: _navigateToMedicineForm,
              child: const Icon(Icons.add),
            );
            final List<Medicamentos> medicamentos = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: medicamentos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${medicamentos[index].nombre}' ' - '' ${medicamentos[index].gramaje}''mg'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineForm(medicamento: medicamentos[index]),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeMedicine(index),
                  ),
                );
              },
            );  
          }
        }
      ),
    );
  }
}
