// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Estudiante estudianteFromJson(String str) => Estudiante.fromJson(json.decode(str));

String estudianteToJson(Estudiante data) => json.encode(data.toJson());

class Estudiante {
  String? id;
  String cedula;
  String nombre;
  String facultad;
  String correo;
  String edad;
  String celular;

  Estudiante({
    this.id,
    required this.cedula,
    required this.nombre,
    required this.facultad,
    required this.correo,
    required this.edad,
    required this.celular
  });

  String toJson() => json.encode(toMap());

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        id: json["id"],
        cedula: json["cedula"],
        nombre: json["nombre"],
        facultad: json["facultad"],
        correo: json["correo"],
        edad: json["edad"],
        celular: json["celular"],
      );

  Map<String, dynamic> toMap() => {
        "id":id,
        "cedula": cedula,
        "nombre": nombre,
        "facultad": facultad,
        "correo": correo,
        "edad": edad,
        "celular": celular,
      };
}
