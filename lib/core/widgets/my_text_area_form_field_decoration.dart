import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';

InputDecoration? MyTextAreaFormFieldDecoration(
    BuildContext context, String label) {
  return InputDecoration(
      counter: Text(''),
      label: Text(label),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultPadding)));
}
