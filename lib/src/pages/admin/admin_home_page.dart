import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/admin/admin_widgets/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_widgets/admin_navigaton_menu.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _userPreferences = UserPreferences();
  late Credential _credential;

  @override
  Widget build(BuildContext context) {
    _credential = Credential.fromJson(jsonDecode(_userPreferences.userData));

    return Scaffold(
        appBar: AdminAppBar(_userPreferences, _credential),
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
      child: Center(
        child: Text('Admin Home Page'),
      ),
    );
  }

}
