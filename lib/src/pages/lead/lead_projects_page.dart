import 'package:flutter/material.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_appbar.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_navigation_menu.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadPrejectsPage extends StatefulWidget {
  const LeadPrejectsPage({Key? key}) : super(key: key);

  @override
  State<LeadPrejectsPage> createState() => _LeadPrejectsPageState();
}

class _LeadPrejectsPageState extends State<LeadPrejectsPage> {
  UserPreferences _userPreferences = UserPreferences();
  late Credential _credential;

  @override
  Widget build(BuildContext context) {
    _credential = credentialFromJson(_userPreferences.userData);

    return Scaffold(
      appBar: LeadAppBar(_userPreferences, _credential),
      body: SafeArea(
          child: Row(children: [
        Flexible(flex: 2, child: LeadNavigationMenu()),
        Flexible(flex: 5, child: _buildCenterPage(context)),
        Flexible(
            flex: 2, child: Container(color: Theme.of(context).primaryColor))
      ])),
      floatingActionButton: Align(
          alignment: FractionalOffset(0.75, 0.98),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'leadNewProjectForm');
            },
          )),
    );
  }

  Widget _buildCenterPage(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('My projects', style: TextStyle(fontSize: 20)),
            Divider(),
            Expanded(child: _buildUsersList(context))
          ],
        ));
  }

  Widget _buildUsersList(BuildContext context) {
    return FutureBuilder(
      future: getMyProjects(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData) return Center(child: Text('No data found.'));
        if (snapshot.data!.statusCode != 1)
          return Center(child: Text('No records.'));

        List<Project> list = [];
        if (snapshot.data!.data.length != 0)
          list = List<Project>.from(snapshot.data!.data
              .map((project) => Project.fromJson(project)));

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
      leading: Icon(Icons.folder),
      title: Text(
        project.toString(),
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(project.area, style: TextStyle(fontSize: 10)),
      trailing: IconButton(
          onPressed: () async {
            final result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Alert(text: 'Do you want to delete the project?');
                });
            if (result) {
              await deleteProject(project.id, _credential.token);
              setState(() {});
            }
          },
          icon: Icon(Icons.delete)),
    );
  }

}
