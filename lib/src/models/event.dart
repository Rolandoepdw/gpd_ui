// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    required this.id,
    required this.eventName,
    required this.description,
    required this.startDate,
    required this.endDate,
    // required this.projectId,
  });

  int id;
  String eventName;
  String description;
  DateTime startDate;
  DateTime endDate;
  // int projectId;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    eventName: json["eventName"],
    description: json["description"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    // projectId: json["projectId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventName": eventName,
    "description": description,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    // "projectId": projectId,
  };

  @override
  String toString() {
    // TODO: implement toString
    return this.eventName;
  }
}
