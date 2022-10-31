import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_edit_profile_form.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_navigation_menu.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadHomePage extends StatefulWidget {
  const LeadHomePage({Key? key}) : super(key: key);

  @override
  State<LeadHomePage> createState() => _LeadHomePageState();
}

class _LeadHomePageState extends State<LeadHomePage> {
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
              Text('${_credential.displayname}',
                  style: TextStyle(fontSize: 22)),
              SizedBox(width: 15)
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await _buildEditBottomSheet();
                  setState((){});
                },
                icon: Icon(Icons.edit, size: 30)),
            SizedBox(width: 15),
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
        ])));
  }

  Widget _buildCenterPage(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Lead Home Page'),
      ),
    );
  }

  Future<void> _buildEditBottomSheet() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return LeadEditProfileForm();
      },
      constraints: BoxConstraints(
          maxWidth: size.width * 0.4,
          minWidth: size.width * 0.4,
          maxHeight: 443,
          minHeight: 443),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
    );
  }

}
