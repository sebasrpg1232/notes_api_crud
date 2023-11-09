import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/estudiante_model.dart';

class EstudianteService extends ChangeNotifier {
  //Asignamos la url base a un atributo para accceder a él facilmente.

  final String _baseUrl = "https://vaya-a627d-default-rtdb.firebaseio.com/";

  late Estudiante selectedEstudiante;

  List<Estudiante> estudiantes = [];

  bool isLoading = false;
  bool isSaving = false;

  EstudianteService() {
    loadEstudiante();
  }

  Future<List<Estudiante>> loadEstudiante() async {
    isLoading = true;
    notifyListeners();

    //Creamos la url a donde vamos a generar la solicitud
    final url = Uri.https(_baseUrl, 'estudiantes.json');
    final resp = await http.get(url);

    final Map<String, dynamic> estudiantesMap = json.decode(resp.body);
    print(estudiantesMap);

    estudiantesMap.forEach((key, value) {
      /**
        * Lo que nos devuelve body es esto:
        safsadfasdf:{
          description: dsfafasfdasf
          title: asdfsfsadfas
        }
         */

      Estudiante tempEstudiante = Estudiante.fromJson(value);
      tempEstudiante.id = key;
      estudiantes.add(tempEstudiante);
    });

    isLoading = false;
    notifyListeners();
    print("hola ${this.estudiantes}");
    return estudiantes;
  }

  Future createOrUpdate(Estudiante estudiante) async {
    isSaving = true;

    if (estudiante.id == null) {
      await createEstudiante(estudiante);
    } else {
      await updateEstudiante(estudiante);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createEstudiante(Estudiante estudiante) async {
    isSaving = true;
    final url = Uri.https(_baseUrl, 'estudiante.json');
    final resp = await http.post(url, body: estudiante.toJson());

    final decodedData = json.decode(resp.body);

    estudiante.id = decodedData['name'];

    estudiantes.add(estudiante);

    return estudiante.id!;
  }

  Future<String> updateEstudiante(Estudiante estudiante) async {
    isSaving = true;
    // final url = Uri.https(_baseUrl, 'notes.json');
    // final resp = await http.put(url, body: note.toJson());

    // final decodedData = json.decode(resp.body);

    // final index = notes.indexWhere((element) => element.id == note.id);

    // notes[index] = note;

    return estudiante.id!;
  }

  Future<String> deleteEstudianteById(String id) async {
    // isLoading = true;
    // final url = Uri.https(_baseUrl, 'notes.json');
    // final resp = await http.delete(url, body: {"name": id});

    // final decodedData = json.decode(resp.body);

    // loadNotes();
    return id;
  }
}
