import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_appbar.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_navigation_menu.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadHomePage extends StatefulWidget {
  const LeadHomePage({Key? key}) : super(key: key);

  @override
  State<LeadHomePage> createState() => _LeadHomePageState();
}

class _LeadHomePageState extends State<LeadHomePage> {
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
        ])));
  }

  Widget _buildCenterPage(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Lead Home Page'),
      ),
    );
  }

}
