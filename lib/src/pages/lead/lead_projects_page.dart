import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_navigation_menu.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadPrejectsPage extends StatefulWidget {
  const LeadPrejectsPage({Key? key}) : super(key: key);

  @override
  State<LeadPrejectsPage> createState() => _LeadPrejectsPageState();
}

class _LeadPrejectsPageState extends State<LeadPrejectsPage> {
  UserPreferences _userPreferences = UserPreferences();

  @override
  Widget build(BuildContext context) {
    Credential _credential = credentialFromJson(_userPreferences.userData);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.person, size: 30),
            SizedBox(width: 15),
            Text('${_credential.displayname}', style: TextStyle(fontSize: 22)),
            SizedBox(width: 15)
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _userPreferences.removeUserPreferencesData();
                Navigator.pushNamed(context, 'login');
              },
              icon: Icon(Icons.logout, size: 30)),
          SizedBox(width: 15),
        ],
        elevation: 5,
      ),
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
      child: Center(
        child: Text('Lead Projects Page'),
      ),
    );
  }

}
