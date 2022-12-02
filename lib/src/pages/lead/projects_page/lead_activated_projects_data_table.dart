import 'package:gpd/bloc/project_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/models/project.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/src/pages/lead/lead_components/lead_edit_project_form.dart';
import 'package:gpd/core/utils/date_utils.dart';

class LeadActivatedProjectsDataTable extends StatefulWidget {
  @override
  State<LeadActivatedProjectsDataTable> createState() =>
      _LeadActivatedProjectsDataTableState();
}

class _LeadActivatedProjectsDataTableState
    extends State<LeadActivatedProjectsDataTable> {
  @override
  Widget build(BuildContext context) {
    ProjectBloc().getMyActivatedProjects();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mis proyectos",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                ElevatedButton(
                    child: Text('Nuevo'),
                    onPressed: () =>
                        Navigator.pushNamed(context, 'leadNewProjectForm'))
              ],
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
                        snapshot.data!.length,
                        (index) =>
                            waitingUserDataRow(context, snapshot.data![index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  DataRow waitingUserDataRow(BuildContext context, Project projectInfo) {
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
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(shortDate(projectInfo.startDate)))),
      // endDate
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(projectInfo.state).withOpacity(.2),
            border: Border.all(color: getRoleColor(projectInfo.state)),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(shortDate(projectInfo.endDate)))),
      // options
      DataCell(Row(
        children: [
          TextButton(
              child: Text('Editar', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LeadEditProjectForm(projectInfo)));
              }),
          SizedBox(
            width: 6,
          ),
          TextButton(
              child:
                  Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
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
                            await ProjectBloc().getMyActivatedProjects();
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          label: Text("Eliminar"))
                    ]);
              }
              // Delete
              ),
        ],
      ))
    ]);
  }
}
