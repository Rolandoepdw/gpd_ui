import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

Future<int> checkRole(BuildContext context, String role) async {
  UserPreferences userPreferences = await UserPreferences();
  if (userPreferences.userData == 'userPreferences error') {
    Navigator.pushNamed(context, 'login');
    return 0;
  } else {
    Credential credential =
        await Credential.fromJson(jsonDecode(userPreferences.userData));
    if (role == 'ADMIN' && !credential.isAdmin) {
      await userPreferences.removeUserPreferencesData();
      Navigator.pushNamed(context, 'login');
      return 0;
    }
    if (role == 'LEAD' && credential.isAdmin) {
      await userPreferences.removeUserPreferencesData();
      Navigator.pushNamed(context, 'login');
      return 0;
    }
    return 1;
  }
}