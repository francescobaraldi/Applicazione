import 'package:Applicazione/Screens/Profilo.dart';
import 'package:flutter/material.dart';
import 'package:Applicazione/Screens/Login.dart';
import 'package:Applicazione/Screens/Registrazione.dart';
import 'package:Applicazione/Screens/ConfermaRegistrazione.dart';
import 'package:Applicazione/Screens/HomePage.dart';
import 'dart:io' show Platform;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        Login.routeName: (context) => Login(title: "Nome App"),
        Registrazione.routeName: (context) =>
            Registrazione(title: "Registrazione"),
        ConfermaRegistrazione.routeName: (context) => ConfermaRegistrazione(),
        HomePage.routeName: (context) => HomePage(title: "Nome App"),
        Profilo.routeName: (context) => Profilo(title: "Profilo"),
      },
    );
  }
}
