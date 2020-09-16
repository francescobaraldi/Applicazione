import 'package:flutter/material.dart';
import 'package:Applicazione/Repository/DataRepository.dart';
import 'package:Applicazione/Repository/SQLiteRepository.dart';
import 'package:Applicazione/Models/Utente.dart';
import 'package:intl/intl.dart';
import 'package:Applicazione/Screens/ConfermaRegistrazione.dart';

class Registrazione extends StatefulWidget {
  static const String routeName = "/Registrazione";
  final String title;
  final DateFormat _df = DateFormat("dd/MM/yyyy");

  Registrazione({Key key, this.title}) : super(key: key);

  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  final _formKey = GlobalKey<FormState>();
  final _pwdKey = GlobalKey<FormFieldState>();
  Utente utente = Utente();
  DataRepository _repository;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _repository = SQLiteRepository();
  }

  void getDate(BuildContext context) async {
    var fDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (fDate != null) {
      setState(() {
        utente.data_nascita = widget._df.format(fDate);
      });
    }
  }

  Future<void> showDialogAlreadyExist() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Attenzione"),
            content: Text("Esiste già un account con questa mail"),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nome",
                  ),
                  onSaved: (value) {
                    utente.nome = value;
                  },
                  validator: (value) {
                    if (value.length == 0)
                      return "Campo obbligatorio";
                    else if (value.length < 3) return "Nome troppo corto";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cognome",
                  ),
                  onSaved: (value) {
                    utente.cognome = value;
                  },
                  validator: (value) {
                    if (value.length == 0)
                      return "Campo obbligatorio";
                    else if (value.length < 3) return "Cognome troppo corto";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onSaved: (value) {
                    utente.email = value;
                  },
                  validator: (value) {
                    if (value.length == 0)
                      return "Campo obbligatorio";
                    else if (value.length < 5) return "Email non valida";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                  onSaved: (value) {
                    utente.username = value;
                  },
                  validator: (value) {
                    if (value.length == 0)
                      return "Campo obbligatorio";
                    else if (value.length < 3) return "Username troppo corto";
                    return null;
                  },
                ),
                TextFormField(
                  key: _pwdKey,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  onSaved: (value) {
                    utente.password = value;
                  },
                  validator: (value) {
                    if (value.length == 0)
                      return "Campo obbligatorio";
                    else if (value.length < 8) return "Password troppo corta";
                    return null;
                  },
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Conferma Passorwd",
                  ),
                  onSaved: (value) => utente.password = value,
                  validator: (value) {
                    if (value != _pwdKey.currentState.value)
                      return "Password non identiche";
                    else
                      return null;
                  },
                  obscureText: true,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Data di nascita"),
                    ),
                    Spacer(),
                    Text(utente.data_nascita == null
                        ? "--/--/----"
                        : utente.data_nascita),
                    IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          getDate(context);
                        }),
                  ],
                ),
                RaisedButton(
                  child: Text("Avanti"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if ((await _repository.get(utente.email)) != null) {
                        showDialogAlreadyExist();
                      } else {
                        _formKey.currentState.save();
                        await _repository.insertUtente(utente);
                        Navigator.pushNamed(
                            context, ConfermaRegistrazione.routeName,
                            arguments: utente);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
