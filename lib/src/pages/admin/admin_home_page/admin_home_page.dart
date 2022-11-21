import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/responsive.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_drawer.dart';
import 'package:gpd/src/pages/admin/admin_home_page/admin_waiting_projects_data_table.dart';
import 'package:gpd/src/pages/admin/admin_home_page/admin_waiting_users_data_table.dart';
import 'package:gpd/src/pages/components/calendart_widget.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/models/user.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/src/models/apiResponse.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
            child: Row(children: [
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
    return Column(children: [
      getWaitingUsers(),
      SizedBox(height: defaultPadding),
      getWaitingProjects()
    ]);
  }

  getWaitingUsers() {
    return FutureBuilder(
      future: getAwaitingUsers(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData)
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: CircularProgressIndicator()));
        if (snapshot.data!.statusCode != 1)
          return AdminWaitingUsersDataTable(_credential, [], refresh);

        List<User> list = [];
        if (snapshot.data!.data["formatedPeople"].length != 0)
          list = List<User>.from(snapshot.data!.data["formatedPeople"]
              .map((user) => User.fromJson(user)));

        return AdminWaitingUsersDataTable(_credential, list, refresh);
      },
    );
  }

  getWaitingProjects() {
    return FutureBuilder(
      future: getProjects(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData)
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: CircularProgressIndicator()));
        if (snapshot.data!.statusCode != 1)
          return AdminWaitingProjectsDataTable(_credential, [], refresh);

        List<Project> list = [];
        if (snapshot.data!.data.length != 0)
          list = List<Project>.from(
              snapshot.data!.data.map((project) => Project.fromJson(project)));

        list.removeWhere((project) => project.state != 'WAITING');

        return AdminWaitingProjectsDataTable(_credential, list, refresh);
      },
    );
  }
}
