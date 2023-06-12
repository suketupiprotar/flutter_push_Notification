

import 'dart:convert';

import 'package:cloud_msg/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(onPressed: (){

          // send notification from one device to another
          notificationServices.getDeviceToken().then((value)async{

            var data = {
              'to' : value.toString(),
              'notification' : {
                'title' : 'Suketu' ,
                'body' : 'Follow me' ,
                "sound": "jetsons_doorbell.mp3"
              },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'type' : 'msj' ,
                'id' : 'SUKETU'
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data) ,
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization' : 'key=AAAA6zsxRak:APA91bGVXexhRsHl3WRXCY5TNkvZF-RgwOnXr6uDyi0EXzsXhSHEGRGfVIijM2K8wl2H335oqp-kbFRHHo2GXWDxAUXjaPpLYdK8f1ORfICWg44LmwlQ5q3bDfRp7V8-UHMiYKPoLkoT'
                }
            ).then((value){
              if (kDebugMode) {
                print(value.body.toString());
              }
            }).onError((error, stackTrace){
              if (kDebugMode) {
                print(error);
              }
            });
          });
        },
            child: Text('Send Notifications')),
      ),
    );
  }
}