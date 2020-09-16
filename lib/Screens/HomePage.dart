import 'package:flutter/material.dart';
import 'package:Applicazione/Repository/DataRepository.dart';
import 'package:Applicazione/Repository/SQLiteRepository.dart';
import 'package:Applicazione/Models/Utente.dart';
import 'package:Applicazione/Screens/Profilo.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/HomePage";
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataRepository _repository;
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _repository = SQLiteRepository();
  }

  void _tapped(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  Widget build(BuildContext context) {
    Utente utente = ModalRoute.of(context).settings.arguments;

    List<Widget> _widgetOptions = <Widget>[
      Text("Home"),
      Text("Ricerca"),
      Text("Profilo"),
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(
                        "contents/images/fotoProfilo.jpeg",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      utente.nome + " " + utente.cognome,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("I miei dati"),
              onTap: () => Navigator.pushNamed(context, Profilo.routeName,
                  arguments: utente),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Impostazioni"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Esci dall'account"),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName("/"));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: _widgetOptions[_bottomIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Cerca"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Profilo"),
          ),
        ],
        onTap: _tapped,
      ),
    );
  }
}
