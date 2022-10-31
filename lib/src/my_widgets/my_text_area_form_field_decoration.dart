import 'package:flutter/material.dart';

InputDecoration? MyTextAreaFormFieldDecoration(
    BuildContext context, String label) {
  return InputDecoration(
      counter: Text(''),
      label: Text(label),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
}
