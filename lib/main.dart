import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpd/src/pages/admin/admin_home_page.dart';
import 'package:gpd/src/pages/admin/admin_users_page.dart';
import 'package:gpd/src/pages/admin/admin_waiting_users_page.dart';
import 'package:gpd/src/pages/create_account_page.dart';
import 'package:gpd/src/pages/lead/lead_home_page.dart';
import 'package:gpd/src/pages/lead/lead_projects_page.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_new_project_form.dart';
import 'package:gpd/src/pages/login_page.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

void main() async {
  UserPreferences userPreferences = UserPreferences();
  await userPreferences.initUserPreferences();

  runApp(const GPD());
}

class GPD extends StatelessWidget {
  const GPD({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Color _primaryColor = Colors.blueAccent;
    // Color _secondaryColor = Colors.white;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPD',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'createAccount': (BuildContext context) => CreateAccauntPage(),
        'adminHome' : (BuildContext context) => AdminHomePage(),
        'adminWaitingUsers' : (BuildContext context) => AdminWaitingUsersPage(),
        'adminUsers' : (BuildContext context) => AdminUsersPage(),
        'leadHome' : (BuildContext context) => LeadHomePage(),
        'leadProjects' : (BuildContext context) => LeadPrejectsPage(),
        'leadNewProjectForm': (BuildContext context) => LeadNewProjectForm(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // Locale('en', ''), // English, no country code
        Locale('es', 'ES'), // Spanish, no country code
      ],
      // theme: ThemeData(
      //   primaryColor: _primaryColor,
      //   appBarTheme: AppBarTheme(backgroundColor: _primaryColor, iconTheme: IconThemeData(color: _secondaryColor)),
      //   iconTheme: IconThemeData(color: _secondaryColor),
      //   listTileTheme: ListTileThemeData(iconColor: _secondaryColor, textColor: _secondaryColor, )
      //
      // ),
    );
  }
}
