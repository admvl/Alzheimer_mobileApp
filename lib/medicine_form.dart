
import 'package:alzheimer_app1/medicine_mgmt.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/welcome_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:alzheimer_app1/models/medicamentos.dart';
import 'package:alzheimer_app1/services/medicamentos_service.dart';
import 'package:alzheimer_app1/services/pacientes_service.dart';
import 'package:alzheimer_app1/utils/token_utils.dart';

class MedicineForm extends StatefulWidget {
  final Medicamentos? medicamento;
  final Pacientes? paciente;

  // Constructor principal
  const MedicineForm({super.key, this.medicamento, this.paciente});

  // Constructor nombrado cuando no se pasa un paciente
  const MedicineForm.withoutPaciente({super.key}) : medicamento = null, paciente = null;

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final PacientesService _pacientesService = PacientesService();
  final MedicamentosService _medicamentosService = MedicamentosService();
  final tokenUtils = TokenUtils();

  @override
  Widget build(BuildContext context) {
    final _roundedDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      fillColor: Colors.blue.withOpacity(0.1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //title: const Text('Registro de Medicamentos'),
        title: Text(widget.medicamento == null?'Registro de Medicamento':'Actualizar Medicamento'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          initialValue: {
            'idMedicamento': widget.medicamento?.idMedicamento,
            'nombreMed': widget.medicamento?.nombre,
            'gramajeMed': widget.medicamento?.gramaje?.toString() ?? '',
            'notasMed':widget.medicamento?.descripcion,
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'nombreMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Nombre del Medicamento'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'gramajeMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Gramaje del Medicamento (mg)'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'notasMed',
                decoration: _roundedDecoration.copyWith(labelText: 'Descripción'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    final formValues = _fbKey.currentState!.value;
                    if(widget.medicamento == null){
                      try {
                        Medicamentos nuevoMedicamento = Medicamentos(
                          nombre: formValues['nombreMed'],
                          gramaje: _parseToDouble(formValues['gramajeMed']),
                          descripcion: formValues['notasMed'],
                          idPaciente: widget.paciente!.idPaciente!,
                        );

                        nuevoMedicamento = await _medicamentosService.crearMedicamento(nuevoMedicamento);
                        final List<Medicamentos> updatedMedicinas = await _medicamentosService.obtenerMedicamentosPorId(widget.paciente!.idPaciente!);
                        Navigator.pop(context, updatedMedicinas.map((medicina) => Medicine(medicina.nombre)).toList());


                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al registrar el medicamento: $e')),
                        );
                      }
                    } else {

                      try {

                        final nuevoMedicamento = Medicamentos(
                        idMedicamento: widget.medicamento?.idMedicamento!,
                        nombre: formValues['nombreMed'],
                        gramaje: _parseToDouble(formValues['gramajeMed']),
                        descripcion: formValues['notasMed'],
                        idPaciente: widget.paciente!.idPaciente!,
                        );
                        await _medicamentosService.actualizarMedicamento(nuevoMedicamento.idMedicamento!, nuevoMedicamento);
                          if(!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Medicamento actualizado con éxito')),
                        );

                        final List<Medicamentos> updatedMedicinas = await _medicamentosService.obtenerMedicamentosPorId(widget.paciente!.idPaciente!);
                          Navigator.pop(context, updatedMedicinas.map((medicina) => Medicine(medicina.nombre)).toList());
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al registrar el medicamento: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _parseToDouble(String? value) {
    if (value == null || value.isEmpty) {
      throw const FormatException("El valor de gramajeMed no puede ser nulo o vacío");
    }
    try {
      return double.parse(value);
    } catch (e) {
      throw const FormatException("El valor de gramajeMed debe ser un número válido");
    }
  }
}


