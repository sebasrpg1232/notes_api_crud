import 'package:flutter/material.dart';
import 'package:notes_api_crud_app/services/estudiante_service.dart';
import 'package:provider/provider.dart';

import '../providers/actual_option_provider.dart';
import '../providers/estudiantes_form_provider.dart';

class CreateEstudianteScreen extends StatelessWidget {
  const CreateEstudianteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EstudianteService estudianteService = Provider.of(context);

    //Creando un provider solo enfocado al formulario
    return ChangeNotifierProvider(
        create: (_) => EstudianteFormProvider(estudianteService.selectedEstudiante),
        child: _CreateForm(estudianteService: estudianteService));
  }
}

class _CreateForm extends StatelessWidget {
  final EstudianteService estudianteService;

  const _CreateForm({required this.estudianteService});

  @override
  Widget build(BuildContext context) {
    final EstudianteFormProvider estudianteFormProvider =
        Provider.of<EstudianteFormProvider>(context);

    final estudiante = estudianteFormProvider.estudiante;

    final ActualOptionProvider actualOptionProvider =
        Provider.of<ActualOptionProvider>(context, listen: false);
    return Form(
      key: estudianteFormProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: estudiante.cedula,
            decoration: const InputDecoration(
                hintText: 'Ingresa tu # de documento',
                labelText: 'Documento',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            onChanged: (value) => estudianteFormProvider.estudiante.cedula = value,
            validator: (value) {
              return value != '' ? null : 'El campo no debe estar vacío';
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: estudiante.nombre,
            decoration: const InputDecoration(
                hintText: 'Ingresa tu nombre completo',
                labelText: 'Nombre',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            onChanged: (value) => estudianteFormProvider.estudiante.nombre = value,
            validator: (value) {
              return value != '' ? null : 'El campo no debe estar vacío';
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            autocorrect: false,
            initialValue: estudiante.correo,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingresa tu correo electrónico',
              labelText: 'Correo',
            ),
            onChanged: (value) => estudiante.correo = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            autocorrect: false,
            initialValue: estudiante.edad,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingresa tu edad',
              labelText: 'Edad',
            ),
            onChanged: (value) => estudiante.edad = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            autocorrect: false,
            initialValue: estudiante.celular,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingresa tu número celular',
              labelText: 'Celular',
            ),
            onChanged: (value) => estudiante.celular = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            autocorrect: false,
            initialValue: estudiante.facultad,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Ingresa tu número celular',
              labelText: 'Facultad',
            ),
            onChanged: (value) => estudiante.facultad = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 15),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: estudianteService.isSaving
                ? null
                : () async {
                    //Quitar teclado al terminar
                    FocusScope.of(context).unfocus();

                    if (!estudianteFormProvider.isValidForm()) return;
                    print("create or update");
                    print(estudianteFormProvider.estudiante.id);
                    await estudianteService.createOrUpdate(estudianteFormProvider.estudiante);
                    actualOptionProvider.selectedOption = 0;
                  },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  estudianteService.isLoading ? 'Espere' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
