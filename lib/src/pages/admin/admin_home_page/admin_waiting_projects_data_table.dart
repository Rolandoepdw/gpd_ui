import 'package:gpd/bloc/project_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/core/widgets/elegent_notification_manager.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/models/project.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/core/utils/date_utils.dart';

class AdminWaitingProjectsDataTable extends StatefulWidget {
  @override
  State<AdminWaitingProjectsDataTable> createState() =>
      _AdminWaitingProjectsDataTableState();
}

class _AdminWaitingProjectsDataTableState
    extends State<AdminWaitingProjectsDataTable> {
  @override
  Widget build(BuildContext context) {
    ProjectBloc().getWatingProjects();

    return Container(
      height: 400,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Solicitudes de proyectos",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Divider(),
            SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<Project>>(
                  stream: ProjectBloc().stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return DataTable(
                      horizontalMargin: 2,
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("Nombre"),
                        ),
                        DataColumn(
                          label: Text("Área"),
                        ),
                        DataColumn(
                          label: Text("Fecha inicial"),
                        ),
                        DataColumn(
                          label: Text("Fecha final"),
                        ),
                        DataColumn(
                          label: Text("Opciones"),
                        ),
                      ],
                      rows: List.generate(
                        snapshot.data!.length,
                        (index) => waitingProjectsDataRow(
                            context, snapshot.data![index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  DataRow waitingProjectsDataRow(BuildContext context, Project projectInfo) {
    return DataRow(cells: [
      DataCell(
        Row(
          children: [
            TextAvatar(
              size: 35,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 14,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: projectInfo.projectName,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                projectInfo.projectName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(projectInfo.area)),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(projectInfo.state).withOpacity(.2),
            border: Border.all(color: getRoleColor(projectInfo.state)),
            borderRadius:
                BorderRadius.all(Radius.circular(5.0)
                    ),
          ),
          child: Text(shortDate(projectInfo.startDate)))),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(projectInfo.state).withOpacity(.2),
            border: Border.all(color: getRoleColor(projectInfo.state)),
            borderRadius:
                BorderRadius.all(Radius.circular(5.0)
                    ),
          ),
          child: Text(shortDate(projectInfo.endDate)))),
      DataCell(Row(children: [
        TextButton(
            child: Text('Activar', style: TextStyle(color: Colors.green)),
            onPressed: () {
              showMyDialog(
                  context: context,
                  icon: Icon(Icons.check_circle, size: 40, color: Colors.green),
                  toDoText: '¿Activar a ${projectInfo.projectName}?',
                  actions: [
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.close,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await SuccessNotification(context, 'Proyecto aceptado con éxito');
                        },
                        label: Text("Cancelar")),
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.check,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () async {
                          await ProjectBloc().aceptProject(projectInfo.id);
                          await ProjectBloc().getWatingProjects();
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        label: Text("Activar"))
                  ]);
            }),
        SizedBox(
          width: 6,
        ),
        TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
            onPressed: () {
              showMyDialog(
                  context: context,
                  icon: Icon(Icons.delete_forever_outlined,
                      size: 36, color: Colors.red),
                  toDoText: '¿Eliminar a ${projectInfo.projectName}?',
                  actions: [
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.close,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: Text("Cancelar")),
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.delete,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          await ProjectBloc().deleteProject(projectInfo.id);
                          await ProjectBloc().getWatingProjects();
                          setState(() {});
                          Navigator.of(context).pop();
                          await SuccessNotification(context, 'Proyecto eliminado con éxito');
                        },
                        label: Text("Eliminar"))
                  ]);
            }
            // Delete
            )
      ]))
    ]);
  }
}
