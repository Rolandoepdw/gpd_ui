import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:gpd/src/pages/admin/admin_widgets/admin_navigaton_menu.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/src/my_widgets/my_alert.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  UserPreferences _userPreferences = UserPreferences();
  late Credential _credential;

  @override
  Widget build(BuildContext context) {
    _credential = Credential.fromJson(jsonDecode(_userPreferences.userData));

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.person, size: 30),
              SizedBox(width: 15),
              Text('${_credential.displayname}',
                  style: TextStyle(fontSize: 22)),
              SizedBox(width: 15)
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _userPreferences.removeUserPreferencesData();
                  Navigator.pushNamed(context, 'login');
                },
                icon: Icon(Icons.logout, size: 30))
          ],
          elevation: 4,
        ),
        body: SafeArea(
          child: Row(
            children: [
              Flexible(flex: 2, child: AdminNavigatonMenu()),
              Flexible(
                flex: 5,
                child: _buildCenterPage(context),
              ),
              Flexible(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          ),
        ));
  }

  Widget _buildCenterPage(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('List of users', style: TextStyle(fontSize: 20)),
            Divider(),
            Expanded(child: _buildAwaitingList(context))
          ],
        ));
  }

  Widget _buildAwaitingList(BuildContext context) {
    return FutureBuilder(
      future: getUsers(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData) return Center(child: Text('No data dound.'));
        if (snapshot.data!.statusCode != 1)
          return Center(child: Text('No records.'));

        List<FullUser> list = [];
        if (snapshot.data!.data["formatedPeople"].length != 0)
          list = List<FullUser>.from(snapshot.data!.data["formatedPeople"]
              .map((user) => FullUser.fromJson(user)));

        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListTile(context, list[index]);
            });
      },
    );
  }

  Widget _buildListTile(BuildContext context, FullUser user) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(
        user.toString(),
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(user.allRole, style: TextStyle(fontSize: 10)),
      trailing: IconButton(
          onPressed: () async {
            final result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Alert(text: 'Do you want to delete the user?');
                });
            if (result) {
              await deleteUsers(user.id, _credential.token);
              await getAwaitingUsers(_credential.token);
              setState(() {});
            }
          },
          icon: Icon(Icons.delete)),
    );
  }
}
