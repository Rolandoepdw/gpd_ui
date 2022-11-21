import 'dart:convert';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

//------------------------------- SingUp & Singin ------------------------------

Future<ApiResponse?> signIn(String phone, String password) async {
  UserPreferences userPreferences = UserPreferences();
  ApiResponse? apiResponse;

  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/auth/signin"),
    body: {"phone": phone, "password": password},
  );
  apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
  if (apiResponse.statusCode == 1) {
    userPreferences.userData = jsonEncode(apiResponse.data);
  }
  return apiResponse;
}

Future<ApiResponse?> signUp(String name, String phone, String password) async {
  UserPreferences userPreferences = UserPreferences();
  ApiResponse? apiResponse;

  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/auth/signup"),
    body: {"displayname": name, "phone": phone, "password": password},
  );
  apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
  if (apiResponse.statusCode == 1) {
    userPreferences.userData = jsonEncode(apiResponse.data);
  }
  return apiResponse;
}

//------------------------------------ Users -----------------------------------

Future<ApiResponse?> getAwaitingUsers(String token) async {
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/person/waiting"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getUsers(String token) async {
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/person"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> aceptUsers(int id, String token) async {
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/person/accept-request?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> deleteUsers(int id, String token) async {
  http.Response response = await http.delete(
      Uri.parse("http://localhost:3000/api/person/delete-profile?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> updateProfile(
    String token, String name, String phone, String password) async {
  UserPreferences userPreferences = UserPreferences();
  ApiResponse? apiResponse;

  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/person/update-profile"),
    headers: {'Authorization': token},
    body: {"displayname": name, "phone": phone, "password": password},
  );
  apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
  if (apiResponse.statusCode == 1) {
    userPreferences.userData = jsonEncode(apiResponse.data);
  }
  return apiResponse;
}

//------------------------------------ Role ------------------------------------

Future<ApiResponse?> setRole(int id, int role, String token) async {
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/person/set-role?personId=$id&roleId=$role"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

//---------------------------------- Projects ----------------------------------

Future<ApiResponse?> createProject(
    String token,
    String projectName,
    String area,
    String startDate,
    String endDate,
    String justification,
    String recomendations) async {
  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/project"),
    headers: {'Authorization': token},
    body: {
      "projectName": projectName,
      "area": area,
      "startDate": startDate,
      "endDate": endDate,
      "justification": justification,
      "recomendations": recomendations,
    },
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> updateProject(
    String token,
    int id,
    String projectName,
    String area,
    String startDate,
    String endDate,
    String justification,
    String recomendations) async {
  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/project/update?id=$id"),
    headers: {'Authorization': token},
    body: {
      "projectName": projectName,
      "area": area,
      "startDate": startDate,
      "endDate": endDate,
      "justification": justification,
      "recomendations": recomendations,
    },
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getMyProjects(String token) async {
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/project/my-projects"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> deleteProject(int id, String token) async {
  http.Response response = await http.delete(
      Uri.parse("http://localhost:3000/api/project?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getProjects(String token) async {
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/project/all-projects"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> aceptProject(int id, String token) async {
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/project/accept?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}


