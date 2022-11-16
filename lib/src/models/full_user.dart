// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:gpd/src/models/role.dart';

FullUser fullUserFromJson(String str) => FullUser.fromJson(json.decode(str));

String fullUserToJson(FullUser data) => json.encode(data.toJson());

class FullUser {
  FullUser({
    required this.id,
    required this.displayname,
    required this.phone,
    required this.roles,
    required this.photo,
    required this.state,
  });

  int id;
  String displayname;
  String phone;
  List<Role> roles;
  String photo;
  String state;

  factory FullUser.fromJson(Map<String, dynamic> json) => FullUser(
    id: json["id"],
    displayname: json["displayname"],
    phone: json["phone"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    photo: json["photo"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayname": displayname,
    "phone": phone,
    "roles": List<Role>.from(roles.map((x) => roleToJson(x))),
    "photo": photo,
    "state": state,
  };

  get allRoles{
    String allRoles = '';
    for(int i = 0; i < roles.length; i++){
      if(i < roles.length -1)
        allRoles += roles[i].name + ', ';
      else
        allRoles += roles[i].name;
    }
    return allRoles;
  }

  @override
  String toString(){
    return '$displayname  $phone';
  }
}