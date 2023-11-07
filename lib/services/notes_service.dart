import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/note_model.dart';

class NotesService extends ChangeNotifier {
  //Asignamos la url base a un atributo para accceder a él facilmente.

  final String _baseUrl = "testapi-ea3c4-default-rtdb.firebaseio.com";

  late Note selectedNote;

  List<Note> notes = [];

  bool isLoading = false;
  bool isSaving = false;

  NotesService() {
    loadNotes();
  }

  Future<List<Note>> loadNotes() async {
    isLoading = true;
    notifyListeners();

    //Creamos la url a donde vamos a generar la solicitud
    final url = Uri.https(_baseUrl, 'notes.json');
    final resp = await http.get(url);

    final Map<String, dynamic> notesMap = json.decode(resp.body);
    print(notesMap);

    notesMap.forEach((key, value) {
      /**
        * Lo que nos devuelve body es esto:
        safsadfasdf:{
          description: dsfafasfdasf
          title: asdfsfsadfas
        }
         */

      Note tempNote = Note.fromJson(value);
      tempNote.id = key;
      notes.add(tempNote);
    });

    isLoading = false;
    notifyListeners();
    print("hola ${this.notes}");
    return notes;
  }

  Future createOrUpdate(Note note) async {
    isSaving = true;

    if (note.id == null) {
      await createNote(note);
    } else {
      await updateNote(note);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createNote(Note note) async {
    isSaving = true;
    final url = Uri.https(_baseUrl, 'notes.json');
    final resp = await http.post(url, body: note.toJson());

    final decodedData = json.decode(resp.body);

    note.id = decodedData['name'];

    notes.add(note);

    return note.id!;
  }

  Future<String> updateNote(Note note) async {
    isSaving = true;
    // final url = Uri.https(_baseUrl, 'notes.json');
    // final resp = await http.put(url, body: note.toJson());

    // final decodedData = json.decode(resp.body);

    // final index = notes.indexWhere((element) => element.id == note.id);

    // notes[index] = note;

    return note.id!;
  }

  Future<String> deleteNoteById(String id) async {
    // isLoading = true;
    // final url = Uri.https(_baseUrl, 'notes.json');
    // final resp = await http.delete(url, body: {"name": id});

    // final decodedData = json.decode(resp.body);

    // loadNotes();
    return id;
  }
}
