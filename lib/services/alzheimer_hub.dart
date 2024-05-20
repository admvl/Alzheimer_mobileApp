import 'package:alzheimer_app1/zone_alarm_scr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRService{
  late HubConnection hubConnection;

  Future<void> initSignalR(BuildContext context) async{
    hubConnection = HubConnectionBuilder()
        .withUrl("Endpoint=http://localhost;Port=8888;AccessKey=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ABCDEFGH;Version=1.0;")
        .build();

    await hubConnection.start();
    setupMessageListener(context);
  }

  void setupMessageListener(BuildContext context){
    hubConnection.on('ReceiveMessage', (List<Object?>? message) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>ZoneAlarmScr()));
    });
  }
}

