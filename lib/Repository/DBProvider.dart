import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print("ECCO L'OUTPUT: " + documentsDirectory.toString());
    String path = join(documentsDirectory.path, "database.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE Utente (nome TEXT, cognome TEXT, email TEXT PRIMARY KEY, data_nascita TEXT, username TEXT, password TEXT)");
    });
  }

  Future<void> close() async {
    if (_database != null) return _database.close();
    return null;
  }
}
