import 'dart:convert';

import 'package:minicurso/utils/helper.dart';

class Event {
  int id;
  String title;
  String description;
  String date;
  String minister;

  Event({
    this.id,
    this.title,
    this.description,
    this.date,
    this.minister,
  });

  static final String element = 'user';

  factory Event.fromSoap(String str) =>
      Event.fromMap(json.decode(str)[element]);

  factory Event.fromJson(String str) => Event.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Event.fromMap(Map<String, dynamic> map) =>
      Event(
        id: convertToInt(map["id"]),
        title: map["title"],
        description: map["description"],
        date: map["date"],
        minister: map["minister"],
      );

  Map<String, dynamic> toMap() =>
      {
        "title": title,
        "description": description,
        "date": date,
        "minister": minister,
      };
}
