import 'package:flutter/material.dart';
import 'package:notes_api_crud_app/services/estudiante_service.dart';
import 'package:provider/provider.dart';

import '../providers/actual_option_provider.dart';

class ListEstudiantesScreen extends StatelessWidget {
  const ListEstudiantesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ListEstudiantes();
  }
}

class _ListEstudiantes extends StatelessWidget {
  void displayDialog(
      BuildContext context, EstudianteService estudianteService, String id) {
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
                    estudianteService.deleteEstudianteById(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    EstudianteService estudianteService = Provider.of<EstudianteService>(context);
    //noteService.loadNotes();
    final estudiantes = estudianteService.estudiantes;

    return ListView.builder(
      itemCount: estudiantes.length,
      itemBuilder: (_, index) => ListTile(
        leading: const Icon(Icons.note),
        title: Text(estudiantes[index].id),
        subtitle: Text(estudiantes[index].toString()),
        trailing: PopupMenuButton(
          // icon: Icon(Icons.fire_extinguisher),
          onSelected: (int i) {
            if (i == 0) {
              estudianteService.selectedEstudiante = estudiantes[index];
              Provider.of<ActualOptionProvider>(context, listen: false)
                  .selectedOption = 1;
              return;
            }

            displayDialog(context, estudianteService, estudiantes[index].id!);
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
