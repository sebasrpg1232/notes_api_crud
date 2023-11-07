import 'package:flutter/material.dart';
import 'package:notes_api_crud_app/services/notes_service.dart';
import 'package:provider/provider.dart';

import '../providers/actual_option_provider.dart';
import '../providers/notes_form_provider.dart';

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotesService noteService = Provider.of(context);

    //Creando un provider solo enfocado al formulario
    return ChangeNotifierProvider(
        create: (_) => NotesFormProvider(noteService.selectedNote),
        child: _CreateForm(noteService: noteService));
  }
}

class _CreateForm extends StatelessWidget {
  final NotesService noteService;

  const _CreateForm({required this.noteService});

  @override
  Widget build(BuildContext context) {
    final NotesFormProvider notesFormProvider =
        Provider.of<NotesFormProvider>(context);

    final note = notesFormProvider.note;

    final ActualOptionProvider actualOptionProvider =
        Provider.of<ActualOptionProvider>(context, listen: false);
    return Form(
      key: notesFormProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: note.title,
            decoration: const InputDecoration(
                hintText: 'Construir Apps',
                labelText: 'Titulo',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            onChanged: (value) => notesFormProvider.note.title = value,
            validator: (value) {
              return value != '' ? null : 'El campo no debe estar vacío';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            maxLines: 10,
            autocorrect: false,
            initialValue: note.description,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Aprender sobre Dart...',
              labelText: 'Descripción',
            ),
            onChanged: (value) => note.description = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: noteService.isSaving
                ? null
                : () async {
                    //Quitar teclado al terminar
                    FocusScope.of(context).unfocus();

                    if (!notesFormProvider.isValidForm()) return;
                    await noteService.createOrUpdate(notesFormProvider.note);
                    actualOptionProvider.selectedOption = 0;
                  },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  noteService.isLoading ? 'Espere' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
