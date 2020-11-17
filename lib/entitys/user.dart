import 'dart:convert';

import 'package:minicurso/utils/helper.dart';
import 'package:minicurso/utils/prefs.dart';

class User {
  int id;
  String code;
  String name;
  String email;
  String token;
  String cpf;
  String image;

  User({
    this.id,
    this.code,
    this.name,
    this.email,
    this.token,
    this.cpf,
    this.image,
  });

  static final String element = 'user';

  factory User.fromSoap(String str) =>
      User.fromMap(json.decode(str)[element]);

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> map) =>
      User(
        id: convertToInt(map["id"]),
        code: map["code"],
        token: map["token"],
        name: map["name"],
        email: map["email"],
        cpf: map["cpf"],
        image: map["image"],
      );

  Map<String, dynamic> toMap() =>
      {
        "code": code,
        "token": token,
        "name": name,
        "cpf": cpf,
        "email": email,
        "image": image,
      };

  void save() => Prefs.setString(element, toJson());

  static Future<User> get() async {
    String prefs = await Prefs.getString(element);
    if (prefs.isEmpty) return null;
    return User.fromJson(prefs);
  }
}
