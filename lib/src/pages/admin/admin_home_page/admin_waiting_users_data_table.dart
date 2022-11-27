import 'package:gpd/bloc/waiting_users_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
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
    WaitingUsersBloc().getWatingUsers();

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
                  stream: WaitingUsersBloc().stream,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
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
                          (index) => waitingUserDataRow(context, snapshot.data![index]),
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
                            child: Column(
                              children: [
                                Text("¿Activar a '${userInfo.displayname}'?"),
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
                                          onPressed: () async {
                                            await WaitingUsersBloc()
                                                .aceptUser(userInfo.id);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          label: Text("Activar"))
                                    ])
                              ],
                            )));
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
                              Text("¿Eliminar a '${userInfo.displayname}'?"),
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
                                        onPressed: () async {
                                          await WaitingUsersBloc()
                                              .removeUser(userInfo.id);
                                          setState(() {});
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
}
