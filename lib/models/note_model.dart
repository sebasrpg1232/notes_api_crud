// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  String? id;
  String title;
  String description;

  Note({
    this.id,
    required this.title,
    required this.description,
  });

  String toJson() => json.encode(toMap());

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        // "id": id,
        "title": title,
        "description": description,
      };
}
