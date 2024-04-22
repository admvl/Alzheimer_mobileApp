import 'package:alzheimer_app1/models/pacientes.dart';
import 'package:alzheimer_app1/models/tipos_notificaciones.dart';

class Notificaciones{
  final String? idNotificacion;
  final String mensaje;
  final DateTime fecha;
  final DateTime hora;
  final Pacientes idPaciente;
  final TiposNotificaciones idTipoNotificacion;


  Notificaciones({
    this.idNotificacion,
    required this.mensaje,
    required this.fecha,
    required this.hora,
    required this.idPaciente,
    required this.idTipoNotificacion,
  });

  factory Notificaciones.fromJson(Map<String, dynamic> json){
    return Notificaciones(
      idNotificacion: json['IdNotificacion'] as String,
      mensaje: json['Mensaje'] as String,
      fecha: DateTime.parse(json['Fecha'] as String),
      hora: DateTime.parse(json['Hora'] as String),
      idPaciente: Pacientes.fromJson(json['IdPaciente']),
      idTipoNotificacion: TiposNotificaciones.fromJson(json['IdTipoNotificacion']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdNotificacion': idNotificacion ?? '',
      'Mensaje': mensaje,
      'Fecha': fecha,
      'Hora': hora,
      'IdPaciente': idPaciente.idPaciente,
      'IdTipoNotificacion': idTipoNotificacion.idTipoNotificacion,
    };
  }
}