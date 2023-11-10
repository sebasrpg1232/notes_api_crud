import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../models/estudiante_model.dart';

class EstudianteService extends ChangeNotifier {
  //Asignamos la url base a un atributo para accceder a él facilmente.

  final String _baseUrl = "vaya-a627d-default-rtdb.firebaseio.com";

  late Estudiante selectedEstudiante;

  List<Estudiante> estudiantes = [];

  bool isLoading = false;
  bool isSaving = false;

  EstudianteService() {
    loadEstudiantes();
  }

  Future<List<Estudiante>> loadEstudiantes() async {
    isLoading = true;
    notifyListeners();

    //Creamos la url a donde vamos a generar la solicitud
    final url = Uri.https(_baseUrl, 'estudiante.json');
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
    if (estudiante.id == "") {
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
    print("CREANDO⏳");

    final decodedData = json.decode(resp.body);

    estudiante.id = decodedData['name'];
    print(estudiante.id);

    estudiantes.add(estudiante);
    print("CREADO✅✅✅");
    return estudiante.id!;
  }

  Future<String> updateEstudiante(Estudiante estudiante) async {
    isSaving = true;
    String? id = estudiante.id;
    String _updateUrl = 'https://vaya-a627d-default-rtdb.firebaseio.com/estudiante/$id.json';
    print("ACTUALIZANDO⏳");
     final url = Uri.parse(_updateUrl);
     print(estudiante.toJson());
     final resp = await http.put(url, body: estudiante.toJson());

     final decodedData = json.decode(resp.body);

     final index = estudiantes.indexWhere((element) => element.id == estudiante.id);

     estudiantes[index] = estudiante;
    print("ACTUALIZADO✅✅✅");
    return estudiante.id!;
  }




  Future<String> deleteEstudianteById(String id) async {
     isLoading = true;
     String _updateUrl = 'https://vaya-a627d-default-rtdb.firebaseio.com/estudiante/$id.json';
     final url = Uri.parse(_updateUrl);
     final resp = await http.delete(url);
     print("ELIMINANDO⏳");

     if (json.decode(resp.body) != []){
       estudiantes.removeWhere((element) => element.id == id);
       loadEstudiantes();
       print("ELIMINADO✅✅✅");
     }
    return id;
  }
}
