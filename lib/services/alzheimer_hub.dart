import 'package:alzheimer_app1/fall_alarm_scr.dart';
import 'package:alzheimer_app1/zone_alarm_scr.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:signalr_netcore/itransport.dart';

class SignalRService{
  late HubConnection? hubConnection;
  final String hubUrl= "http://192.168.137.1:5066/notificationHub";
  bool isZoneAlarmScreenOpen = false;
  bool isFallAlarmScreenOpen = false;
  //final String hubUrl= "https://alzheimernotification.service.signalr.net";

  Future<void> initSignalR(BuildContext context, List<String> deviceIds) async{
    /*hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,options: HttpConnectionOptions(
          accessTokenFactory: () async => createJwt("https://alzheimernotification.service.signalr.net","55bk4htt6YS9gkmL2Gm88jyBmQ2/q3L4iZv3nI0ASis=")
        ))
        .build();*/
    hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
          options:HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
          ),
        )
        .build();

    hubConnection?.onclose(({error}) {
      print('Connection Closed: $error');
    });

    try{
      await hubConnection?.start();
    }catch(error){
      print('Error connecting to SignalR: $error');
      return;
    }
    await subscribeToDevices(deviceIds);
    if(context.mounted){
      setupLocationUpdateListener(context);
      setupLocationOut(context);
      setupFallListener(context);
      setupNotFoundListener(context);
      //setupMessageListener(context);
    }
  }

  void setupLocationUpdateListener(BuildContext context){
    hubConnection?.on('ReceiveLocationUpdate', (List<Object?>? message) {
      if(message != null){
        final String mac = message[0] as String;
        final double latitude = message[1] as double;
        final double longitude = message[2] as double;
        final String fechaHora = message[3] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('Location update: $mac is at ($latitude, $longitude) at $fechaHora');

        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(content: Text('Ubicación actualizada: $mac está en ($latitude, $longitude) a las $fechaHora')),
        //);
      }
    });
  }


  void setupLocationOut(BuildContext context){
    hubConnection?.on('ReceiveLocationOut', (List<Object?>? message) {
      if(message != null){
        final String mac = message[0] as String;
        final double latitude = message[1] as double;
        final double longitude = message[2] as double;
        final String fechaHora = message[3] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('Fuera de zona segura el dispositivo: $mac is at ($latitude, $longitude) at $fechaHora');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fuera de zona segura el dispositivo: $mac está en ($latitude, $longitude) a las $fechaHora')),
        );
        if(!isZoneAlarmScreenOpen) {
          isZoneAlarmScreenOpen = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ZoneAlarmScr()
              )
          ).then((_) {
            isZoneAlarmScreenOpen = false;
          });
        }
      }
    });
  }

  void setupFallListener(BuildContext context){
    hubConnection?.on('ReceiveFall', (List<Object?>? message) {
      if(message != null){
        final String mac = message[0] as String;
        final String fechaHora = message[1] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('El paciente ha caido: $mac a las $fechaHora');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El paciente ha caido: $mac a las $fechaHora')),
        );
        if(!isFallAlarmScreenOpen) {
          isFallAlarmScreenOpen = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FallAlarmScr()
              )
          ).then((_) {
            isFallAlarmScreenOpen = false;
          });
        }
      }
    });
  }


  void setupNotFoundListener(BuildContext context){
    hubConnection?.on('ReceiveNotFound', (List<Object?>? message) {
      if(message != null){
        final String mac = message[0] as String;
        final String fechaHora = message[1] as String;
        // Aquí puedes manejar la actualización de la ubicación
        print('El paciente ha perdido la conexion: $mac a las $fechaHora');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El paciente ha perdido la conexion: $mac a las $fechaHora')),
        );
        /*if(!isFallAlarmScreenOpen) {
          isFallAlarmScreenOpen = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FallAlarmScr()
              )
          ).then((_) {
            isFallAlarmScreenOpen = false;
          });
        }*/
      }
    });
  }

  Future<void> subscribeToDevices(List<String> deviceIds) async {
    if(hubConnection!=null){
      try{
        print(deviceIds);
        await hubConnection!.invoke("SubscribeToDevices", args: [deviceIds]);
      }catch(error){
        print('Error suscribing to devices: $error');
      }
    }else{
      print('HubConnection is not initialized.');
    }
  }

  void setupMessageListener(BuildContext context){
    hubConnection?.on('ReceiveMessage', (List<Object?>? message) {
      for(var item in message!){
        print(message);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) =>const ZoneAlarmScr()));
    });
  }
  String createJwt(String aud, String key) {
    final header = {
      "alg": "HS256",
      "typ": "JWT"
    };
    final payload = {
      "aud": aud,
      "exp": DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000
    };

    String base64Header = base64Url.encode(utf8.encode(json.encode(header))).replaceAll('=', '');
    String base64Payload = base64Url.encode(utf8.encode(json.encode(payload))).replaceAll('=', '');

    var secret = utf8.encode(key);
    var signature = Hmac(sha256, secret).convert(utf8.encode('$base64Header.$base64Payload'));
    String base64Signature = base64Url.encode(signature.bytes).replaceAll('=', '');

    return '$base64Header.$base64Payload.$base64Signature';
  }
}

