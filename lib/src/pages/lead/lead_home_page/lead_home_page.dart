import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/responsive.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/pages/components/calendart_widget.dart';
import 'package:gpd/src/pages/lead/lead_components/lead_appbar.dart';
import 'package:gpd/src/pages/lead/lead_home_page/lead_waiting_projects_data_table.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/src/models/apiResponse.dart';

import '../lead_components/lead_drawer.dart';

class LeadHomePage extends StatefulWidget {
  const LeadHomePage({Key? key}) : super(key: key);

  @override
  State<LeadHomePage> createState() => _LeadHomePageState();
}

class _LeadHomePageState extends State<LeadHomePage> {
  final _userPreferences = UserPreferences();
  late Credential _credential;

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    _credential = Credential.fromJson(jsonDecode(_userPreferences.userData));

    return Scaffold(
        appBar: LeadAppBar(_userPreferences, _credential),
        drawer: LeadDrawer(),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: LeadDrawer(),
            ),
          Expanded(flex: 5, child: LeadDashboard(context))
        ])));
  }

  Widget LeadDashboard(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      getMyWaitingProjects(),
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

  getMyWaitingProjects() {
    return FutureBuilder(
      future: getMyProjects(_credential.token),
      builder: (BuildContext context, AsyncSnapshot<ApiResponse?> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        if (snapshot.data!.statusCode != 1)
          LeadWaitingProjectsDataTable(_credential, [], refresh);

        List<Project> list = [];
        if (snapshot.data!.data.length != 0)
          list = List<Project>.from(
              snapshot.data!.data.map((project) => Project.fromJson(project)));

        list.removeWhere((project) => project.state != 'WAITING');

        return LeadWaitingProjectsDataTable(_credential, list, refresh);
      },
    );
  }
}
