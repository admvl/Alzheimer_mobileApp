import 'dart:async';
import 'package:alzheimer_app1/device_conection_scr.dart';
import 'package:alzheimer_app1/fall_alarm_scr.dart';
import 'package:alzheimer_app1/medicine_alarm_scr.dart';
import 'package:alzheimer_app1/services/location_provider.dart';
import 'package:alzheimer_app1/zone_alarm_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

import '../models/location_data.dart';

class SignalRService {
  late HubConnection? hubConnection;
  final String hubUrl =
      //"https://alzheimerwebapi.azurewebsites.net/notificationHub";
      "http://192.168.68.108:5066/notificationHub";
  bool isZoneAlarmScreenOpen = false;
  bool isFallAlarmScreenOpen = false;
  bool isDisconnectedScreenOpen = false;
  Timer? _notificationTimer;
  Timer? _notificationFallTimer;
  Timer? _notificationConnectionTimer;
  final storage = const FlutterSecureStorage();
  List<String> _deviceIds = [];

  Future<void> initSignalR(BuildContext context, List<String> deviceIds) async {
    _deviceIds = deviceIds;
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception("Token not found");
    }
    hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    hubConnection?.onclose(({error}) {
      print('Connection Closed: $error');
    });

    try {
      await hubConnection?.start();
    } catch (error) {
      print('Error connecting to SignalR: $error');
      return;
    }
    await subscribeToDevices(deviceIds);
    if (context.mounted) {
      setupLocationUpdateListener(context);
      setupLocationOut(context);
      setupFallListener(context);
      setupNotFoundListener(context);
      setupAlarmListener(context);
      //setupMessageListener(context);
    }
  }

  void setupLocationUpdateListener(BuildContext context) {
    hubConnection?.on('ReceiveLocationUpdate', (List<Object?>? message) {
      if (message != null) {
        final String mac = message[0] as String;
        final double latitude = message[1] is double
            ? message[1] as double
            : double.parse(message[1].toString());
        final double longitude = message[2] is double
            ? message[2] as double
            : double.parse(message[2].toString());
        final String fechaHora = message[3] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print(
            'Location update: $mac is at ($latitude, $longitude) at $fechaHora');
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        locationProvider.updateLocation(LocationData(
            mac: mac,
            latitude: latitude,
            longitude: longitude,
            fechaHora: fechaHora));
      }
    });
  }

  void setupLocationOut(BuildContext context) {
    hubConnection?.on('ReceiveLocationOut', (List<Object?>? message) async {
      if (message != null &&
          (_notificationTimer == null || !_notificationTimer!.isActive)) {
        final String mac = message[0] as String;
        final double latitude = message[1] as double;
        final double longitude = message[2] as double;
        final String fechaHora = message[3] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print(
            'Fuera de zona segura el dispositivo: $mac is at ($latitude, $longitude) at $fechaHora');

        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Fuera de zona segura el dispositivo: $mac está en ($latitude, $longitude) a las $fechaHora')),
        );*/
        if (!isZoneAlarmScreenOpen) {
          final nombrepaciente = await storage.read(key: mac);
          isZoneAlarmScreenOpen = true;
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ZoneAlarmScr(
                        nombrepaciente: nombrepaciente,
                      ))).then((_) {
            isZoneAlarmScreenOpen = false;
          });
        }

        _notificationTimer = Timer(const Duration(minutes: 1), () {
          _notificationTimer = null;
        });
      }
    });
  }
  void setupAlarmListener(BuildContext context) {
    hubConnection?.on('ReceiveMedicationNotification', (List<Object?>? message) async {
      if (message != null) {
        final String mac = message[0] as String;
        final String hora = message[1] as String;
        final String mensaje = message[2] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('Alarma del paciente: $mac a las $hora');

        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Alarma del dispositivo: $mac a la $hora')),
        );*/
        if (!isFallAlarmScreenOpen) {
          final nombrepaciente = await storage.read(key: mac);
          isFallAlarmScreenOpen = true;
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MedicineAlarmScr(nombrepaciente:nombrepaciente
                  ))).then((_) {
            isFallAlarmScreenOpen = false;
          });
        }
      }
    });
  }

  void setupFallListener(BuildContext context) {
    hubConnection?.on('ReceiveFall', (List<Object?>? message) async {
      if (message != null) {
        final String mac = message[0] as String;
        final String fechaHora = message[1] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('El paciente ha caido: $mac a las $fechaHora');

        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('El paciente ha caido: $mac a las $fechaHora')),
        );*/
        if (!isFallAlarmScreenOpen) {
          final nombrepaciente = await storage.read(key: mac);
          isFallAlarmScreenOpen = true;
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FallAlarmScr(
                        nombrepaciente: nombrepaciente,
                      ))).then((_) {
            isFallAlarmScreenOpen = false;
          });
        }
      }
    });
  }

  void setupNotFoundListener(BuildContext context) {
    hubConnection?.on('ReceiveNotFound', (List<Object?>? message) async {
      if (message != null &&
          (_notificationTimer == null || !_notificationTimer!.isActive)) {
        final String mac = message[0] as String;
        final String fechaHora = message[1] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('El paciente ha perdido la conexion: $mac a las $fechaHora');

        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'El paciente ha perdido la conexion: $mac a las $fechaHora')),
        );*/
        if (!isDisconnectedScreenOpen) {
          final nombrepaciente = await storage.read(key: mac);
          isDisconnectedScreenOpen = true;
          if (!context.mounted) return;
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ConnectionStatusPage(nombrepaciente: nombrepaciente)))
              .then((_) {
            isDisconnectedScreenOpen = false;
          });
        }
        _notificationTimer = Timer(const Duration(minutes: 1), () {
          _notificationTimer = null;
        });
      }
    });
  }

  Future<void> subscribeToDevices(List<String> deviceIds) async {
    if (hubConnection != null) {
      try {
        print(deviceIds);
        await hubConnection!.invoke("SubscribeToDevices", args: [deviceIds]);
      } catch (error) {
        print('Error suscribing to devices: $error');
      }
    } else {
      print('HubConnection is not initialized.');
    }
  }

  Future<void> unsubscribeFromDevices() async {
    if (hubConnection != null &&
        hubConnection!.state == HubConnectionState.Connected) {
      try {
        print('Desuscribiendo de dispositivos: $_deviceIds');
        await hubConnection!
            .invoke("UnsubscribeFromDevices", args: [_deviceIds]);
      } catch (error) {
        print('Error desuscribiéndose de dispositivos: $error');
      }
    } else {
      print('HubConnection no está inicializado o no está conectado.');
    }
  }

  Future<void> clearStorage() async {
    await storage.deleteAll();
  }
}
