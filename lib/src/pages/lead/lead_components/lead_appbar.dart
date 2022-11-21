import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/responsive.dart';
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
  Size get preferredSize => Size.fromHeight(50);
}

class _LeadAppBarState extends State<LeadAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: (Responsive.isDesktop(context)) ? false : true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: TextAvatar(
              size: 5,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 18,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Circular,
              text: widget._credential.displayname,
            ),
          ),
          SizedBox(width: 30),
          Text('${widget._credential.displayname}',
              style: TextStyle(fontSize: 18)),
          SizedBox(width: 15)
        ],
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await _buildEditBottomSheet();
              setState(() {});
            },
            icon: Icon(Icons.edit, size: 25)),
        SizedBox(width: 15),
        IconButton(
            onPressed: () {
              widget._userPreferences.removeUserPreferencesData();
              Navigator.pushNamed(context, 'login');
            },
            icon: Icon(Icons.logout, size: 25)),
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
          topLeft: Radius.circular(defaultBorderRadius),
          topRight: Radius.circular(defaultBorderRadius),
        ),
      ),
    );
  }
}
