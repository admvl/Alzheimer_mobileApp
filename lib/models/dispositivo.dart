import 'dart:ffi';

class Dispositivo{
  final String fecha;
  final String hora;
  final Float latitud;
  final Float longitud;
  final int chars;
  final int sentencias;
  final int checksum;
  final Float aceleracionX;
  final Float aceleracionY;
  final Float aceleracionZ;
  final Float giroX;
  final Float giroY;
  final Float giroZ;
  final String direccionMAC;

  const Dispositivo(
    this.fecha, 
    this.hora, 
    this.latitud, 
    this.longitud, 
    this.chars, 
    this.sentencias, 
    this.checksum, 
    this.aceleracionX,
    this.aceleracionY,
    this.aceleracionZ,
    this.giroX,
    this.giroY,
    this.giroZ,
    this.direccionMAC
  );
}


final List<Dispositivo> dispositivo = 
  _dispositivo.map((e)=> Dispositivo(
    e['fecha'] as String, 
    e['hora'] as String, 
    e['latitud'] as Float, 
    e['longitud'] as Float, 
    e['chars'] as int,
    e['sentencias'] as int,
    e['checksum'] as int, 
    e['aceleracionX']as Float,
    e['aceleracionY']as Float,
    e['aceleracionZ']as Float,
    e['giroX']as Float,
    e['giroY']as Float,
    e['giroZ']as Float,
    e['direccionMAC'] as String
  )
).toList(growable: false);


final List<Map<String, Object>> _dispositivo = [
  {
    "fecha": "2024-03-26",
    "hora": "15:30:45",
    "latitud": -12.3456789,
    "longitud": 45.6789123,
    "chars": 42,
    "sentencias": 73,
    "checksum": 18,
    "aceleracion_x": -2.345,
    "aceleracion_y": 5.678,
    "aceleracion_z": 9.012,
    "giro_x": -1.234,
    "giro_y": 3.456,
    "giro_z": -7.890,
    "direccionMAC": "00:11:22:33:44:55"
  },
];