import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

checkRole(BuildContext context, String role) async {
  UserPreferences userPreferences = await UserPreferences();
  if (userPreferences.userData == 'userPreferences error') {
    return Navigator.pushNamed(context, 'login');
  } else {
    Credential credential =
        Credential.fromJson(jsonDecode(userPreferences.userData));
    if (role == 'ADMIN' && !credential.isAdmin) {
      userPreferences.removeUserPreferencesData();
      return Navigator.pushNamed(context, 'login');
    }
    if (role == 'LEAD' && credential.isAdmin) {
      userPreferences.removeUserPreferencesData();
      return Navigator.pushNamed(context, 'login');
    }
  }
}
