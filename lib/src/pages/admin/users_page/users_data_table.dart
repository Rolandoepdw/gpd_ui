import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/src/provider/http_provider.dart';

class UsersDataTable extends StatelessWidget {
  Credential _credential;
  List<FullUser> _users = [];
  Function _callBack;

  UsersDataTable(this._credential, this._users, this._callBack);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
              "Usuarios",
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
                  DataColumn(
                    label: Text("Id"),
                  ),
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
                  _users.length,
                  (index) => waitingUserDataRow(
                      context, _users[index], _credential, _callBack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow waitingUserDataRow(BuildContext context, FullUser userInfo,
    Credential credential, Function callBack) {
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
    DataCell(Text('${userInfo.id}')),
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
    DataCell(TextButton(
        child: Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                    title: Center(
                        child: Column(children: [
                      Icon(Icons.warning_outlined, size: 36, color: Colors.red),
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
                                      await deleteUsers(
                                          userInfo.id, credential.token);
                                      callBack();
                                      Navigator.of(context).pop();
                                    },
                                    label: Text("Eliminar"))
                              ])
                        ])));
              });
        }
        // Delete
        ))
  ]);
}
