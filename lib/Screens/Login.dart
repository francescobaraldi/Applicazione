import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Applicazione/Screens/Registrazione.dart';
import 'package:Applicazione/Screens/HomePage.dart';
import 'package:Applicazione/Repository/DataRepository.dart';
import 'package:Applicazione/Repository/SQLiteRepository.dart';
import 'package:Applicazione/Models/Utente.dart';

class Login extends StatefulWidget {
  static const routeName = "/";
  final String title;

  Login({Key key, this.title}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoginDisabled = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  DataRepository _repository;
  Utente utente = Utente();

  @override
  void initState() {
    super.initState();
    _repository = SQLiteRepository();
  }

  Future<void> showDialogNotExist() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Attenzione"),
            content: Text("Non esiste un account con questa mail"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> showDialogError() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Errore"),
            content: Text("Username o password errati"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _inputChanged(String value) {
    setState(() {
      isLoginDisabled =
          (emailController.text.length == 0 || pwdController.text.length == 0);
    });
  }

  _loginPressed() async {
    utente = await _repository.get(emailController.text);
    if (utente != null) {
      if (pwdController.text == utente.password) {
        Navigator.pushNamed(context, HomePage.routeName, arguments: utente);
      } else {
        showDialogError();
      }
    } else {
      showDialogNotExist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              Text(
                "Effettua il login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                controller: emailController,
                onChanged: _inputChanged,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                controller: pwdController,
                onChanged: _inputChanged,
                obscureText: true,
              ),
              RaisedButton(
                child: Text("Accedi"),
                onPressed: isLoginDisabled ? null : _loginPressed,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Non hai un account?"),
                  FlatButton(
                      child: Text("Iscriviti",
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                      onPressed: () => Navigator.pushNamed(
                          context, Registrazione.routeName)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
