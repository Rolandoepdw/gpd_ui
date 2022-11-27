import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';

showMyDialog(
    {required BuildContext context,
    required Icon icon,
    required String toDoText,
    required List<Widget> actions}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return MyAlertDialog(icon, toDoText, actions);
    },
  );
}

class MyAlertDialog extends StatelessWidget {
  Icon _icon;
  String _toDoText;
  List<Widget> _actions;

  MyAlertDialog(this._icon, this._toDoText, this._actions);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: _icon,
      content: Text(_toDoText, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      actions: _actions,
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.only(bottom: defaultPadding),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
    );
  }
}
