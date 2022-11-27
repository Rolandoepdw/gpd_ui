import 'package:flutter/material.dart';
import 'package:gpd/bloc/users_bloc.dart';
import 'package:gpd/responsive.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_appbar.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_drawer.dart';
import 'package:gpd/src/pages/admin/users_page/users_data_table.dart';
import 'package:gpd/src/pages/components/calendart_widget.dart';
import 'package:gpd/core/constants/color_constants.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersBloc().getActivatedUsers();

    return Scaffold(
        appBar: AdminAppBar(),
        drawer: const AdminDrawer(),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            const Expanded(
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
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildCenterPage(context),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) CalendarWidget()
                    ],
                  )),
              if (!Responsive.isMobile(context))
                const SizedBox(width: defaultPadding),
              // On Mobile means if the screen is less than 850 we dont want to show it
              if (!Responsive.isMobile(context))
                Expanded(flex: 2, child: CalendarWidget())
            ])));
  }

  Widget _buildCenterPage(BuildContext context) {
    return UsersDataTable();
  }
}
