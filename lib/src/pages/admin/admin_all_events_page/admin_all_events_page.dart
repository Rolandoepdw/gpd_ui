import 'package:flutter/material.dart';
import 'package:gpd/core/widgets/calendar/calendar_widget.dart';
import 'package:gpd/core/utils/responsive.dart';
import 'package:gpd/src/pages/admin/admin_all_events_page/admin_all_events_data_table.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_drawer.dart';
import 'package:gpd/core/constants/color_constants.dart';

class AdminAllEventsPage extends StatelessWidget {
  const AdminAllEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AdminAppBar(),
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
    return AdminAllEventsDataTable();
  }
}
