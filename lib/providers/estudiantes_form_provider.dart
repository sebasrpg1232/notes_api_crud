import 'package:flutter/material.dart';

import '../models/estudiante_model.dart';

class EstudianteFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Estudiante estudiante;

  EstudianteFormProvider(this.estudiante);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
