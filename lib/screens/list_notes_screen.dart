import 'package:flutter/material.dart';
import 'package:notes_api_crud_app/services/notes_service.dart';
import 'package:provider/provider.dart';

import '../providers/actual_option_provider.dart';

class ListNotesScreen extends StatelessWidget {
  const ListNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ListNotes();
  }
}

class _ListNotes extends StatelessWidget {
  void displayDialog(
      BuildContext context, NotesService noteService, String id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text('Alerta!'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Quiere eliminar definitivamente el registro?'),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    noteService.deleteNoteById(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    NotesService noteService = Provider.of<NotesService>(context);
    //noteService.loadNotes();
    final notes = noteService.notes;

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (_, index) => ListTile(
        leading: const Icon(Icons.note),
        title: Text(notes[index].title),
        subtitle: Text(notes[index].id.toString()),
        trailing: PopupMenuButton(
          // icon: Icon(Icons.fire_extinguisher),
          onSelected: (int i) {
            if (i == 0) {
              noteService.selectedNote = notes[index];
              Provider.of<ActualOptionProvider>(context, listen: false)
                  .selectedOption = 1;
              return;
            }

            displayDialog(context, noteService, notes[index].id!);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 0, child: Text('Actualizar')),
            const PopupMenuItem(value: 1, child: Text('Eliminar'))
          ],
        ),
      ),
    );
  }
}
