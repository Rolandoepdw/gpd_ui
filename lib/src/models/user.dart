// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:gpd/src/models/role.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.displayname,
    required this.phone,
    required this.roles,
  });

  int id;
  String displayname;
  String phone;
  List<Role> roles;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    displayname: json["displayname"],
    phone: json["phone"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayname": displayname,
    "phone": phone,
    "roles": List<Role>.from(roles.map((x) => roleToJson(x))),
  };

  get allRole{
    String allRole = '';
    for(int i = 0; i < roles.length; i++){
      if(i < roles.length -1)
        allRole += roles[i].name + ', ';
      else
        allRole += roles[i].name;
    }
    return allRole;
  }

  @override
  String toString(){
    return '$displayname  $phone';
  }
}
