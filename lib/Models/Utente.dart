class Utente {
  String nome;
  String cognome;
  String email;
  String data_nascita;
  String username;
  String password;

  Utente(
      {this.nome,
      this.cognome,
      this.email,
      this.data_nascita,
      this.username,
      this.password});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cognome': cognome,
      'email': email,
      'data_nascita': data_nascita,
      'username': username,
      'password': password,
    };
  }

  factory Utente.fromMap(Map<String, dynamic> map) {
    return Utente(
      nome: map['nome'],
      cognome: map['cognome'],
      email: map['email'],
      data_nascita: map['data_nascita'],
      username: map['username'],
      password: map['password'],
    );
  }
}
