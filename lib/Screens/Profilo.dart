import 'package:Applicazione/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:Applicazione/Repository/DataRepository.dart';
import 'package:Applicazione/Repository/SQLiteRepository.dart';
import 'package:Applicazione/Models/Utente.dart';
import 'package:intl/intl.dart';

class Profilo extends StatefulWidget {
  static const String routeName = "/HomePage/Profilo";
  final String title;
  final DateFormat _df = DateFormat("dd/MM/yyyy");

  Profilo({Key key, this.title}) : super(key: key);

  _ProfiloState createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  DataRepository _repository;
  final _formKey = GlobalKey<FormState>();
  bool modificheOn = false;
  String button = "Modifica";
  DateTime _selectedDate = DateTime.now();
  Utente utenteAppoggio = Utente();
  Utente utenteTmp = Utente();
  bool visibility_off = true;

  @override
  void initState() {
    super.initState();
    _repository = SQLiteRepository();
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

  void getDate(BuildContext context) async {
    var fDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (fDate != null) {
      setState(() {
        utenteAppoggio.data_nascita = widget._df.format(fDate);
      });
    }
  }

  Widget build(BuildContext context) {
    Utente utente = ModalRoute.of(context).settings.arguments;
    TextEditingController dataController = TextEditingController();
    dataController.text = utenteAppoggio.data_nascita == null
        ? utente.data_nascita
        : utenteAppoggio.data_nascita;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, HomePage.routeName,
                    arguments: utente);
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "I miei dati",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Nome",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    initialValue: utente.nome,
                    onSaved: (value) => utente.nome = value,
                    validator: (value) {
                      if (value.length == 0)
                        return "Campo obbligatorio";
                      else if (value.length < 3) return "Nome troppo corto";
                      return null;
                    },
                    enabled: modificheOn,
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Cognome",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    initialValue: utente.cognome,
                    onSaved: (value) => utente.cognome = value,
                    validator: (value) {
                      if (value.length == 0)
                        return "Campo obbligatorio";
                      else if (value.length < 3) return "Cognome troppo corto";
                      return null;
                    },
                    enabled: modificheOn,
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    initialValue: utente.email,
                    onSaved: (value) => utenteAppoggio.email = value,
                    validator: (value) {
                      if (value.length == 0)
                        return "Campo obbligatorio";
                      else if (value.length < 5) return "Email non valida";
                      return null;
                    },
                    enabled: modificheOn,
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Data di nascita",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    controller: dataController,
                    enabled: false,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: modificheOn == false
                          ? null
                          : () {
                              getDate(context);
                            }),
                ),
                ListTile(
                  leading: Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    initialValue: utente.username,
                    onSaved: (value) => utente.username = value,
                    validator: (value) {
                      if (value.length == 0)
                        return "Campo obbligatorio";
                      else if (value.length < 3) return "Username troppo corto";
                      return null;
                    },
                    enabled: modificheOn,
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    enabled: modificheOn,
                    initialValue: utente.password,
                    onSaved: (value) => utente.password = value,
                    validator: (value) {
                      if (value.length == 0)
                        return "Campo obbligatorio";
                      else if (value.length < 3) return "Password troppo corta";
                      return null;
                    },
                    obscureText: visibility_off,
                  ),
                  trailing: IconButton(
                    icon: visibility_off
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        visibility_off = !visibility_off;
                      });
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(button),
                  onPressed: () async {
                    setState(() {
                      if (button == "Modifica") {
                        button = "Salva";
                        modificheOn = true;
                      } else if (button == "Salva") {
                        button = "Modifica";
                        modificheOn = false;
                      }
                    });
                    if (button == "Modifica") {
                      if (_formKey.currentState.validate()) {
                        utente.data_nascita = dataController.text;
                        _formKey.currentState.save();
                        utenteTmp.email = utente.email;
                        utente.email = utenteAppoggio.email;
                        if ((await _repository.get(utente.email)) == null) {
                          await _repository.put(utenteTmp.email, utente);
                        } else {
                          setState(() {
                            utente.email = utenteTmp.email;
                            button = "Salva";
                            modificheOn = true;
                            showDialogAlreadyExist();
                          });
                        }
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
