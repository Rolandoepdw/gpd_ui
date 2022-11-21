import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/responsive.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_drawer.dart';
import 'package:gpd/src/pages/admin/users_page/users_data_table.dart';
import 'package:gpd/src/pages/components/calendart_widget.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/src/models/apiResponse.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _userPreferences = UserPreferences();
  late Credential _credential;

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    _credential = Credential.fromJson(jsonDecode(_userPreferences.userData));

    return Scaffold(
        appBar: AdminAppBar(_userPreferences, _credential),
        drawer: AdminDrawer(),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: AdminDrawer(),
            ),
          Expanded(flex: 5, child: AdminDashboard(context))
        ])));
  }

  Widget AdminDashboard(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildCenterPage(context),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) CalendarWidget()
                    ],
                  )),
              if (!Responsive.isMobile(context))
                SizedBox(width: defaultPadding),
              // On Mobile means if the screen is less than 850 we dont want to show it
              if (!Responsive.isMobile(context))
                Expanded(flex: 2, child: CalendarWidget())
            ])));
  }

  Widget _buildCenterPage(BuildContext context) {
    return getActivatedUsers();
  }

  getActivatedUsers() {
    return FutureBuilder(
      future: getUsers(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        if (snapshot.data!.statusCode != 1)
          return Center(child: Text('No records.'));

        List<FullUser> list = [];
        if (snapshot.data!.data["formatedPeople"].length != 0)
          list = List<FullUser>.from(snapshot.data!.data["formatedPeople"]
              .map((user) => FullUser.fromJson(user)));

        list.removeWhere((element) => element.state == 'WAITING');

        return UsersDataTable(_credential, list, refresh);
      },
    );
  }
}
