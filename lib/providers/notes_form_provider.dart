import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NotesFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Note note;

  NotesFormProvider(this.note);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
