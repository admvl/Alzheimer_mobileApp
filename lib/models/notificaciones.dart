import 'package:flutter/material.dart';

class Notificaciones {
  final String? idNotificacion;
  final String mensaje;
  final DateTime? fecha;
  final TimeOfDay hora;
  final String idPaciente;
  final String idTipoNotificacion;
  final bool? enviada;

  Notificaciones({
    this.idNotificacion,
    required this.mensaje,
    this.fecha,
    required this.hora,
    required this.idPaciente,
    required this.idTipoNotificacion,
    this.enviada,
  });

  factory Notificaciones.fromJson(Map<String, dynamic> json) {
    var fecha = null;
    if(json['Fecha']!=null) {
      fecha = DateTime.parse(json['Fecha'] as String);
    }
    final horaString = json['Hora'] as String;
    final horaParts = horaString.split(':');
    final hora = TimeOfDay(
        hour: int.parse(horaParts[0]), minute: int.parse(horaParts[1]));

    return Notificaciones(
      idNotificacion: json['IdNotificacion'] as String?,
      mensaje: json['Mensaje'] as String,
      fecha: fecha,
      hora: hora,
      idPaciente: json['IdPaciente'] as String,
      idTipoNotificacion: json['IdTipoNotificacion'] as String,
      enviada: json['Enviada'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final horaString = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}:00';
    return {
      if(idNotificacion!=null)'IdNotificacion': idNotificacion,
      'Mensaje': mensaje,
      'Fecha': fecha?.toIso8601String(),
      'Hora': horaString,
      'IdPaciente': idPaciente,
      'IdTipoNotificacion': idTipoNotificacion,
      'Enviada': enviada
    };
  }
}
