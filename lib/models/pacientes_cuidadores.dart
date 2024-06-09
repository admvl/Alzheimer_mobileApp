import 'package:alzheimer_app1/models/cuidadores.dart';
import 'package:alzheimer_app1/models/dias.dart';
import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PacientesCuidadores {
  final String? idCuidaPaciente;
  final String idPaciente;
  final String idCuidador;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final Dias? dias;

  PacientesCuidadores({
    this.idCuidaPaciente,
    required this.idPaciente,
    required this.idCuidador,
    required this.horaInicio,
    required this.horaFin,
    this.dias,
  });

  factory PacientesCuidadores.fromJson(Map<String, dynamic> json) {
    final timeInicio = DateFormat('HH:mm:ss').parse(json['HoraInicio']);
    final timeFin = DateFormat('HH:mm:ss').parse(json['HoraFin']);
    return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente'] as String?,
      idPaciente: json['IdPaciente'] as String,
      idCuidador: json['IdCuidador'] as String,
      horaInicio: TimeOfDay(hour: timeInicio.hour, minute: timeInicio.minute),
      horaFin: TimeOfDay(hour: timeFin.hour, minute: timeFin.minute),
      dias: json['Dia'] != null ? Dias.fromJson(json['Dia']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    final inicioDateTime = DateTime(now.year, now.month, now.day, horaInicio.hour, horaInicio.minute);
    final finDateTime = DateTime(now.year, now.month, now.day, horaFin.hour, horaFin.minute);
    return {
      'IdCuidaPaciente': idCuidaPaciente ?? '',
      'IdPaciente': idPaciente,
      'IdCuidador': idCuidador,
      'HoraInicio': DateFormat('HH:mm:ss').format(inicioDateTime),
      'HoraFin': DateFormat('HH:mm:ss').format(finDateTime),
      'Dias': dias?.toJson(),
    };
  }
}
