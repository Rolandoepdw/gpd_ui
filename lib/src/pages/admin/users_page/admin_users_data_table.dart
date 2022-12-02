import 'package:gpd/bloc/full_user_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class AdminUsersDataTable extends StatefulWidget {
  @override
  State<AdminUsersDataTable> createState() => _AdminUsersDataTableState();
}

class _AdminUsersDataTableState extends State<AdminUsersDataTable> {
  @override
  Widget build(BuildContext context) {
    FullUserBloc().getActivatedUsers();
    return Container(
      height: 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Usuarios activos",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<FullUser>>(
                  stream: FullUserBloc().stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return DataTable(
                      horizontalMargin: 2,
                      columnSpacing: defaultPadding,
                      columns: [
                        const DataColumn(
                          label: Text("Nombre"),
                        ),
                        const DataColumn(
                          label: Text("Id"),
                        ),
                        const DataColumn(
                          label: Text("Teléfono"),
                        ),
                        const DataColumn(
                          label: Text("Roles"),
                        ),
                        const DataColumn(
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

  DataRow waitingUserDataRow(BuildContext context, FullUser userInfo) {
    return DataRow(cells: [
      // displayname
      DataCell(Row(children: [
        TextAvatar(
          size: 35,
          backgroundColor: Colors.white,
          textColor: Colors.white,
          fontSize: 14,
          upperCase: true,
          numberLetters: 1,
          shape: Shape.Rectangle,
          text: userInfo.displayname,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              userInfo.displayname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ))
      ])),
      // id
      DataCell(Text('${userInfo.id}')),
      // phone
      DataCell(Text(userInfo.phone)),
      // roles
      DataCell(Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.allRoles[0]).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.allRoles[0])),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(userInfo.allRoles))),
      // options
      DataCell(TextButton(
          child:
              const Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
          onPressed: () {
            showMyDialog(
                context: context,
                icon: Icon(Icons.delete_forever_outlined,
                    size: 40, color: Colors.red),
                toDoText: "¿Eliminar a ${userInfo.displayname}?",
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
                      label: Text('Cancel')),
                  ElevatedButton.icon(
                      icon: Icon(
                        Icons.delete,
                        size: 14,
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        await FullUserBloc().removeUser(userInfo.id);
                        await FullUserBloc().getActivatedUsers();
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      label: Text('Eliminar'))
                ]);
          }))
    ]);
  }
}
