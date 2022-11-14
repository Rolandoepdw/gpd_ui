import 'package:flutter/material.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

import 'lead_edit_profile_form.dart';

class LeadAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserPreferences _userPreferences;
  final Credential _credential;

  LeadAppBar(this._userPreferences, this._credential);

  @override
  State<LeadAppBar> createState() => _LeadAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _LeadAppBarState extends State<LeadAppBar> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () async {
              await _buildEditBottomSheet();
              setState(() {});
            },
            icon: Icon(Icons.edit, size: 30)),
        SizedBox(width: 15),
        IconButton(
            onPressed: () {
              widget._userPreferences.removeUserPreferencesData();
              Navigator.pushNamed(context, 'login');
            },
            icon: Icon(Icons.logout, size: 30)),
        SizedBox(width: 15),
      ],
      elevation: 5,
    );
  }

  Future<void> _buildEditBottomSheet() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return LeadEditProfileForm();
      },
      constraints: BoxConstraints(
          maxWidth: size.width * 0.4,
          minWidth: size.width * 0.4,
          maxHeight: 443,
          minHeight: 443),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
    );
  }
}
