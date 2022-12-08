import 'package:flutter/material.dart';
import 'package:gpd/core/widgets/calendar/calendar_widget.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_drawer.dart';
import 'package:gpd/src/pages/admin/admin_home_page/admin_waiting_projects_data_table.dart';
import 'package:gpd/src/pages/admin/admin_home_page/admin_waiting_users_data_table.dart';
import 'package:gpd/core/constants/color_constants.dart';
import '../../../../core/utils/responsive.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AdminAppBar(),
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
                      _buildCenterPage(),
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

  Widget _buildCenterPage() {
    return Column(children: [
      AdminWaitingUsersDataTable(),
      SizedBox(height: defaultPadding),
      AdminWaitingProjectsDataTable()
    ]);
  }
}
