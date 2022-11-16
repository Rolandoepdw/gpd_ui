import 'package:flutter/material.dart';

Color getRoleColor(String? role) {
  if (role == "ADMIN")
    return Colors.green;
  else if (role == "LEAD")
    return Colors.red;
  else if (role == "GENERAL") return Colors.blueAccent;
  return Colors.black38;
}
