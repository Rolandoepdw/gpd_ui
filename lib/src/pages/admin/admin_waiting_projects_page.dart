import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/models/user.dart';
import 'package:gpd/src/pages/admin/admin_widgets/admin_navigaton_menu.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/src/my_widgets/my_alert.dart';

class AdminWaitingProjectsPage extends StatefulWidget {
  const AdminWaitingProjectsPage({Key? key}) : super(key: key);

  @override
  State<AdminWaitingProjectsPage> createState() =>
      _AdminWaitingProjectsPageState();
}

class _AdminWaitingProjectsPageState extends State<AdminWaitingProjectsPage> {
  UserPreferences _userPreferences = UserPreferences();
  late Credential _credential;

  @override
  Widget build(BuildContext context) {
    _credential = Credential.fromJson(jsonDecode(_userPreferences.userData));

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(Icons.person, size: 30),
            SizedBox(width: 15),
            Text('${_credential.displayname}', style: TextStyle(fontSize: 22)),
            SizedBox(width: 15)
          ]),
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
            child: Row(children: [
          Flexible(flex: 2, child: AdminNavigatonMenu()),
          Flexible(flex: 5, child: _buildCenterPage(context)),
          Flexible(
              flex: 2, child: Container(color: Theme.of(context).primaryColor))
        ])));
  }

  Widget _buildCenterPage(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Text('Projects waiting to be activated',
              style: TextStyle(fontSize: 20)),
          Divider(),
          Expanded(child: _buildAwaitingProjectsList(context))
        ]));
  }

  Widget _buildAwaitingProjectsList(BuildContext context) {
    return FutureBuilder(
      future: getProjects(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData) return Center(child: Text('No data dound.'));
        if (snapshot.data!.statusCode != 1)
          return Center(child: Text('No records.'));

        List<Project> list = [];
        if (snapshot.data!.data.length != 0)
          list = List<Project>.from(
              snapshot.data!.data.map((project) => Project.fromJson(project)));

        list.removeWhere((project) => project.state != 'WAITING');

        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListTile(context, list[index]);
            });
      },
    );
  }

  Widget _buildListTile(BuildContext context, Project project) {
    return ListTile(
        onTap: () {},
        leading: Icon(Icons.create_new_folder),
        title: Text(project.toString(), style: TextStyle(fontSize: 16)),
        subtitle: Text(project.area, style: TextStyle(fontSize: 10)),
        trailing: Container(
            width: 100,
            child: Row(children: [
              IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Alert(
                              text: 'Do you want to activate the project?');
                        });
                    if (result) {
                      await aceptProject(project.id, _credential.token);
                      // await setRole(person.id, 2, _credential.token); // falta el id de la persona
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.check)),
              SizedBox(width: 20),
              IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Alert(
                              text: 'Do you want to delete the project?');
                        });
                    if (result) {
                      await deleteProject(project.id, _credential.token);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.delete))
            ])));
  }
}
