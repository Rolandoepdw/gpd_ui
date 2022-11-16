import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  String text;

  Alert({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alert!'),
      content: SingleChildScrollView(
        child: Text(text),
      ),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () => Navigator.of(context).pop(false)),
        TextButton(
            child: const Text('Acept'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () => Navigator.of(context).pop(true))
      ],
    );
  }
}
