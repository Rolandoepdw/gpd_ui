import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpd/src/pages/admin/admin_home_page.dart';
import 'package:gpd/src/pages/admin/admin_users_page.dart';
import 'package:gpd/src/pages/admin/admin_projects_page.dart';
import 'package:gpd/src/pages/create_account_page.dart';
import 'package:gpd/src/pages/lead/lead_home_page.dart';
import 'package:gpd/src/pages/lead/lead_projects_page.dart';
import 'package:gpd/src/pages/lead/lead_widgets/lead_new_project_form.dart';
import 'package:gpd/src/pages/login_page.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:gpd/core/constants/color_constants.dart';

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
          'adminHome': (BuildContext context) => AdminHomePage(),
          'adminUsers': (BuildContext context) => AdminUsersPage(),
          'leadHome': (BuildContext context) => LeadHomePage(),
          'leadProjects': (BuildContext context) => LeadPrejectsPage(),
          'leadNewProjectForm': (BuildContext context) => LeadNewProjectForm(),
          'adminProjects': (BuildContext context) => AdminProjectsPage(),
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
        theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 5),
          scaffoldBackgroundColor: bgColor,
          primaryColor: greenColor,
          dialogBackgroundColor: secondaryColor,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: greenColor,
              selectionColor: greenColor.withOpacity(0.5)),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: greenColor),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: greenColor),
                  borderRadius: BorderRadius.circular(defaultPadding)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: greenColor),
                  borderRadius: BorderRadius.circular(defaultPadding))),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: secondaryColor,
              foregroundColor: greenColor,
              hoverColor: greenColor.withOpacity(0.1)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                  foregroundColor: MaterialStateProperty.all(greenColor),
                  overlayColor:
                      MaterialStateProperty.all(greenColor.withOpacity(0.1)))),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(bgColor),
                  foregroundColor: MaterialStateProperty.all(greenColor),
                  overlayColor:
                      MaterialStateProperty.all(greenColor.withOpacity(0.1)))),
          progressIndicatorTheme: ProgressIndicatorThemeData(color: greenColor),
          canvasColor: secondaryColor,
        ));
  }
}
