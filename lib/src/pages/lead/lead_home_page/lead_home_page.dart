import 'package:flutter/material.dart';
import 'package:gpd/responsive.dart';
import 'package:gpd/src/pages/components/calendart_widget.dart';
import 'package:gpd/src/pages/lead/lead_components/lead_appbar.dart';
import 'package:gpd/src/pages/lead/lead_home_page/lead_waiting_projects_data_table.dart';
import 'package:gpd/core/constants/color_constants.dart';

import '../lead_components/lead_drawer.dart';

class LeadHomePage extends StatelessWidget {
  const LeadHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LeadAppBar(),
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

  _buildCenterPage() {
    return LeadWaitingProjectsDataTable();
  }
}
