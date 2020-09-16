import 'package:flutter/material.dart';
import 'package:Applicazione/Models/Utente.dart';
import 'package:Applicazione/Screens/Login.dart';

class ConfermaRegistrazione extends StatelessWidget {
  static const String routeName = "/ConfermaRegistrazione";
  Widget build(BuildContext context) {
    Utente utente = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Registrazione avvenuta con successo! I tuoi dati sono:"),
                Text(utente.nome),
                Text(utente.cognome),
                Text(utente.email),
                Text(utente.data_nascita),
                Text(utente.username),
                Text(utente.password),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Effettua il login"),
                    FlatButton(
                      child:
                          Text("Login", style: TextStyle(color: Colors.blue)),
                      onPressed: () =>
                          Navigator.pushNamed(context, Login.routeName),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
