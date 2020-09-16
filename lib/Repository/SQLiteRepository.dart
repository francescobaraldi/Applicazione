import 'package:Applicazione/Models/Utente.dart';
import 'package:Applicazione/Repository/DBProvider.dart';
import 'package:Applicazione/Repository/DataRepository.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteRepository extends DataRepository {
  DBProvider _dbp;

  SQLiteRepository() {
    _dbp = DBProvider.instance;
  }

  @override
  Future<int> insertUtente(Utente user) async {
    Database db = await _dbp.database;
    var ret = await db.insert('Utente', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return ret;
  }

  @override
  Future<void> closeDB() {
    return null;
  }

  @override
  Future<bool> delete(String email) async {
    Database db = await _dbp.database;

    int count =
        await db.delete('Utente', where: "email = ?", whereArgs: [email]);
    return count == 1;
  }

  @override
  Future<Utente> get(String email) async {
    Database db = await _dbp.database;

    List<Map<String, dynamic>> maps =
        await db.query('Utente', where: "email = ?", whereArgs: [email]);
    if (maps.length > 0) {
      return Utente.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Utente>> getAll() async {
    Database db = await _dbp.database;

    List<Map<String, dynamic>> data = await db.query('Utente');

    List<Utente> utenti = data.map<Utente>((user) {
      return Utente.fromMap(user);
    }).toList();
    return utenti;
  }

  @override
  Future<bool> put(String email, Utente user) async {
    Database db = await _dbp.database;

    int count = await db
        .update('Utente', user.toMap(), where: "email = ?", whereArgs: [email]);
    return count == 1;
  }
}
