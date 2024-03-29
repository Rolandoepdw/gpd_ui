import 'dart:convert';

import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/core/utils/responsive.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

import '../../../../core/widgets/edit_profile_form.dart';

class LeadAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<LeadAppBar> createState() => _LeadAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}

class _LeadAppBarState extends State<LeadAppBar> {
  @override
  Widget build(BuildContext context) {
    final userPreferences = UserPreferences();
    final credential =
    Credential.fromJson(jsonDecode(userPreferences.userData));
    return AppBar(

      automaticallyImplyLeading: (Responsive.isDesktop(context)) ? false : true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: TextAvatar(
              size: 5,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 18,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Circular,
              text: credential.displayname,
            ),
          ),
          const SizedBox(width: 20),
          Text('${credential.displayname}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 15)
        ],
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await buildEditBottomSheet(context);
              setState(() {});
            },
            icon: const Icon(Icons.edit, size: 25)),
        const SizedBox(width: 15),
        IconButton(
            onPressed: () {
              userPreferences.removeUserPreferencesData();
              Navigator.pushNamed(context, 'login');
            },
            icon: const Icon(Icons.logout, size: 25)),
        const SizedBox(width: 15),
      ],
      elevation: 5,
    );
  }

}
