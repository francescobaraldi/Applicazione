import 'package:Applicazione/Models/Utente.dart';

abstract class DataRepository {
  Future<List<Utente>> getAll();
  Future<Utente> get(String email);
  Future<bool> delete(String email);
  Future<int> insertUtente(Utente user);
  Future<bool> put(String email, Utente user);
  Future<void> closeDB();
}
