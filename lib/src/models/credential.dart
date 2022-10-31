// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Credential credentialFromJson(String str) => Credential.fromJson(json.decode(str));

String credentialToJson(Credential data) => json.encode(data.toJson());

class Credential {
  Credential({
    required this.token,
    required this.phone,
    required this.displayname,
    required this.isAdmin,
  });

  String token;
  String phone;
  String displayname;
  bool isAdmin;

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    token: json["token"],
    phone: json["phone"],
    displayname: json["displayname"],
    isAdmin: json["isAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "phone": phone,
    "displayname": displayname,
    "isAdmin": isAdmin,
  };

}
