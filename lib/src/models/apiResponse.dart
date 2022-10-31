// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ApiResponse responseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String responseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  int statusCode;
  List<dynamic> message;
  dynamic data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        statusCode: json["statusCode"],
        message: List<dynamic>.from(json["message"].map((x) => x)),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
      };

}
