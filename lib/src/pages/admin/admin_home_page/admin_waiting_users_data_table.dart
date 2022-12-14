import 'package:gpd/bloc/user_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/core/widgets/elegent_notification_manager.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/models/user.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class AdminWaitingUsersDataTable extends StatefulWidget {
  @override
  State<AdminWaitingUsersDataTable> createState() =>
      _AdminWaitingUsersDataTableState();
}

class _AdminWaitingUsersDataTableState
    extends State<AdminWaitingUsersDataTable> {
  @override
  Widget build(BuildContext context) {
    UsersBloc().getAllWaitingUsers();

    return Container(
        height: 400,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Solicitudes de usuarios",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Divider(),
          SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<User>>(
                  stream: UsersBloc().stream,
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
                            label: Text("Teléfono"),
                          ),
                          DataColumn(
                            label: Text("Roles"),
                          ),
                          DataColumn(
                            label: Text("Opciones"),
                          ),
                        ],
                        rows: List.generate(
                          snapshot.data!.length,
                          (index) => waitingUserDataRow(
                              context, snapshot.data![index]),
                        ));
                  }))
        ])));
  }

  DataRow waitingUserDataRow(BuildContext context, User userInfo) {
    return DataRow(cells: [
      // displayname
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
              text: userInfo.displayname,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                userInfo.displayname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // id
      // DataCell(Text('${userInfo.id}')),
      // phone
      DataCell(Text(userInfo.phone)),
      // roles
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.allRoles[0]).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.allRoles[0])),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(userInfo.allRoles))),
      // options
      DataCell(Row(children: [
        TextButton(
            child: Text('Activar', style: TextStyle(color: Colors.green)),
            onPressed: () {
              showMyDialog(
                  context: context,
                  icon: Icon(Icons.check_circle, size: 40, color: Colors.green),
                  toDoText: '¿Activar a ${userInfo.displayname}?',
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
                          Icons.check,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () async {
                          await UsersBloc().aceptUser(userInfo.id);
                          await UsersBloc().getAllWaitingUsers();
                          setState(() {});
                          Navigator.of(context).pop();
                          await SuccessNotification(context, 'Usuario activado con éxito');
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
                  toDoText: '¿Eliminar a ${userInfo.displayname}?',
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
                          await UsersBloc().removeUser(userInfo.id);
                          await UsersBloc().getAllWaitingUsers();
                          setState(() {});
                          Navigator.of(context).pop();
                          await SuccessNotification(context, 'Usuario eliminado con éxito');
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
