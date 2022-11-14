import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserPreferences _userPreferences;
  final Credential _credential;

  AdminAppBar(this._userPreferences, this._credential);

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _AdminAppBarState extends State<AdminAppBar> {
  @override
  AppBar build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.person, size: 35),
            SizedBox(width: 15),
            Text('${widget._credential.displayname}',
                style: TextStyle(fontSize: 22)),
            SizedBox(width: 15)
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                widget._userPreferences.removeUserPreferencesData();
                Navigator.pushNamed(context, 'login');
              },
              icon: Icon(Icons.logout, size: 30))
        ]);
  }
}
