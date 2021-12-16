// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:teste01/notification_badge.dart';

import 'model/pushnotification_model.dart';
import 'package:http/http.dart' as http;
Future<void> main() async{

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'HRO | TI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _senha = TextEditingController();


  late final FirebaseMessaging messaging;
  late int _totalNotificationCounter;
  //chamada do modelo criado na pasta lib/model
  PushNotification? _notificationInfo;

  //registrar a notificação no firebase
  void registerNotification() async{
    await Firebase.initializeApp();

    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted the permission");


      messaging.getToken().then((token) async {
        print(token);
          try{
            var response = await http.post(
                Uri.parse("https://8064-45-171-27-124.ngrok.io/etl/query-post/?cod_query=post_token_app"),
                body: json.encode([token, ""])

            );
            print(json.encode(response.body));

          } catch(e){
            print(e);
          }

      });



      FirebaseMessaging.onMessage.listen((RemoteMessage message ) {
          PushNotification notification = PushNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body'],
          );
          setState(() {
            _totalNotificationCounter ++;
            _notificationInfo = notification;
          });

          if(notification != null){
            showSimpleNotification(
              Text(_notificationInfo!.title!),
              leading:
                NotificationBadge(totalNotification: _totalNotificationCounter),
                subtitle: Text(_notificationInfo!.body!),
                background: Colors.cyan.shade700,
                duration: Duration(seconds: 2)
            );
          }
      });
    }

    else{
      print("Permission declined");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
    });
    registerNotification();

    _totalNotificationCounter = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Future<void>getSenha(_senha) async{
      messaging.getToken().then((token) async {
        final url = Uri.parse("https://8064-45-171-27-124.ngrok.io/etl/query-put/?cod_query=put_token_app");
        final d = json.encode([_senha,token]);
        print(token);
        print(_senha);
        final headers = {"Content-type": "application/json"};

        var response = await http.put(
            url,
            headers: headers,
            body: d,
          encoding: Encoding.getByName("utf-8"),
        );
        print('Status code: ${response.statusCode}');
        print('Body: ${response.body}');

      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pushnotification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("FlutterPushNotification",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12,),
            NotificationBadge(totalNotification: _totalNotificationCounter),
            _notificationInfo != null ?Column( crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Title: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}"),
              SizedBox(height: 9,),
              Text("Body: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}"),
              SizedBox(height: 9,),
            ]): Container(),
            TextField(
              controller: _senha,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: "Digite sua senha",
              ),
            ),
            ElevatedButton(onPressed: () => getSenha(_senha.text),
                child: Text("Enviar")
              ),
          ],
        ),
      ),
    );
  }
}
