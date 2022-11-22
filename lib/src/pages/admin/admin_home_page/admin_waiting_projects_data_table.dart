import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/project.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/core/utils/date_utils.dart';

class AdminWaitingProjectsDataTable extends StatelessWidget {
  Credential _credential;
  List<Project> _projects = [];
  Function _callBack;

  AdminWaitingProjectsDataTable(this._credential, this._projects, this._callBack);

  @override
  Widget build(BuildContext context) {
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
              child: DataTable(
                horizontalMargin: 2,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Nombre"),
                  ),
                  // DataColumn(
                  //   label: Text("Id"),
                  // ),
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
                  _projects.length,
                  (index) => waitingProjectsDataRow(
                      context, _projects[index], _credential, _callBack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow waitingProjectsDataRow(BuildContext context, Project projectInfo,
    Credential credential, Function callBack) {
  return DataRow(cells: [
    // projectName
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
    // id
    // DataCell(Text('${projectInfo.id}')),
    // area
    DataCell(Text(projectInfo.area)),
    // startDate
    DataCell(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: getRoleColor(projectInfo.state).withOpacity(.2),
          border: Border.all(color: getRoleColor(projectInfo.state)),
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius) //
              ),
        ),
        child: Text(shortDate(projectInfo.startDate)))),
    // endDate
    DataCell(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: getRoleColor(projectInfo.state).withOpacity(.2),
          border: Border.all(color: getRoleColor(projectInfo.state)),
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius) //
              ),
        ),
        child: Text(shortDate(projectInfo.endDate)))),
    // options
    DataCell(Row(children: [
      TextButton(
          child: Text('Activar', style: TextStyle(color: primaryColor)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                      title: Center(
                        child: Column(
                          children: [
                            Icon(Icons.warning_outlined,
                                size: 36, color: Colors.red),
                            SizedBox(height: 20),
                            Text("Confirmar"),
                          ],
                        ),
                      ),
                      content: Container(
                          color: secondaryColor,
                          height: 70,
                          child: Column(children: [
                            Text("¿Activar a '${projectInfo.projectName}'?"),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.check,
                                        size: 14,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () async {
                                        await aceptProject(
                                            projectInfo.id, credential.token);
                                        callBack();
                                        Navigator.of(context).pop();
                                      },
                                      label: Text("Activar"))
                                ])
                          ])));
                });
          }),
      SizedBox(
        width: 6,
      ),
      TextButton(
          child: Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                      title: Center(
                          child: Column(children: [
                        Icon(Icons.warning_outlined,
                            size: 36, color: Colors.red),
                        SizedBox(height: 20),
                        Text("Confirmar"),
                      ])),
                      content: Container(
                          color: secondaryColor,
                          height: 70,
                          child: Column(children: [
                            Text("¿Eliminar a '${projectInfo.projectName}'?"),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 14,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () async {
                                        await deleteProject(
                                            projectInfo.id, credential.token);
                                        callBack();
                                        Navigator.of(context).pop();
                                      },
                                      label: Text("Eliminar"))
                                ])
                          ])));
                });
          }
          // Delete
          )
    ]))
  ]);
}
