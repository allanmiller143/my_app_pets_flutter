// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:replica_google_classroom/controller/userController.dart';



Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Title: ${message.notification?.body}');
  print('Title: ${message.data}');

}

class FirebaseNotification {

  MeuControllerGlobal meuControllerGlobal = Get.find();
  late String FCMToken;
  final firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotications() async {
    await firebaseMessaging.requestPermission();
    FCMToken = (await firebaseMessaging.getToken())!;
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    meuControllerGlobal.token = FCMToken;
    print(FCMToken);
  }


  Future<void> sendNotificationToUser(String recipientToken, String title, String body) async {
    const String serverKey = 'AAAAEk-LdDM:APA91bEQP32Ybm3qk6cXjeG7ndaVfBXacPcpA7etMI1xhG8AEZLDR3M3bw2h0I7IV7xO9bxAeSg0ATZybRP_fHIfZrMPJl2pke3t-OHxye1ZzxIs4j9HFKNkRmXjx61RSF39xJ9Bvfd3'; // Substitua pelo seu servidor Firebase Cloud Messaging (FCM) Key

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
    };

    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK', // Adapte conforme necessário
      'data': {
        // Adicione dados adicionais, se necessário
        'key1': 'value1',
        'key2': 'value2',
      },
    };

    final Map<String, dynamic> requestBody = {
      'to': recipientToken,
      'notification': notification,
      'data': data,
      'priority': 'high',
    };

    final http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> send(token,titulo,corpo) async {
    String recipientToken = token;
    String title = titulo;
    String body = corpo;
    await sendNotificationToUser(recipientToken, title, body);
  }


} 

