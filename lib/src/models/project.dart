// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Project projectFromJson(String str) => Project.fromJson(json.decode(str));

String projectToJson(Project data) => json.encode(data.toJson());

class Project {
  Project({
    required this.id,
    required this.projectName,
    required this.area,
    required this.logo,
    required this.justification,
    required this.recomendations,
    required this.state,
    required this.startDate,
    required this.endDate,
  });

  int id;
  String projectName;
  String area;
  String? logo;
  String? justification;
  String? recomendations;
  String state;
  DateTime startDate;
  DateTime endDate;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    projectName: json["projectName"],
    area: json["area"],
    logo: json["logo"],
    justification: json["justification"],
    recomendations: json["recomendations"],
    state: json["state"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "projectName": projectName,
    "area": area,
    "logo": logo,
    "justification": justification,
    "recomendations": recomendations,
    "state": state,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
  };

  @override
  String toString(){
    return projectName;
  }
}
