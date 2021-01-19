import 'package:firebase_auth/firebase_auth.dart';

class UserApp{

  String _idUser;
  String _name;
  String _email;
  String _password;
  String _photo;

  UserApp();

    Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUser"      : this.idUser,
      "name"        : this.name,
      "email"       : this.email,
      "photo"       : this.photo
    };
    return map;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  static Future<User> get() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    return user;
  }
}