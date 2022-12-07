import 'dart:convert';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
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
    body: {
      "displayname": name,
      "phone": phone,
      "password": password,
      "photo": "photo"
    },
  );
  apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
  if (apiResponse.statusCode == 1) {
    userPreferences.userData = jsonEncode(apiResponse.data);
  }
  return apiResponse;
}

//------------------------------------ Users -----------------------------------

Future<ApiResponse?> getWaitingUsers() async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/person/waiting"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getUsers() async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/person"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> aceptUsers(int id) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/person/accept-request?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> deleteUsers(int id) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.delete(
      Uri.parse("http://localhost:3000/api/person/delete-profile?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> updateProfile(
    String name, String phone, String password) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
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

Future<ApiResponse?> setRole(int id, int role) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
      Uri.parse(
          "http://localhost:3000/api/person/set-role?personId=$id&roleId=$role"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

//---------------------------------- Projects ----------------------------------

Future<ApiResponse?> createProject(
    String projectName,
    String area,
    String startDate,
    String endDate,
    String justification,
    String recomendations) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
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

Future<ApiResponse?> updateProjects(
    int id,
    String projectName,
    String area,
    String startDate,
    String endDate,
    String justification,
    String recomendations) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
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

Future<ApiResponse?> getMyProjects() async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/project/my-projects"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> deleteProjects(int id) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.delete(
      Uri.parse("http://localhost:3000/api/project?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getProjects() async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
    Uri.parse("http://localhost:3000/api/project/all-projects"),
    headers: {"Authorization": token},
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> aceptProjects(int id) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/project/accept?id=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

//----------------------------------- Events -----------------------------------

Future<ApiResponse?> createEvent(
    String eventName,
    String description,
    String startDate,
    String endDate,
    int projectId) async {


  Map<String, dynamic> obj = {
    'eventName': eventName,
    'description': description,
    'startDate': startDate,
    'endDate': endDate,
    'projectId': projectId
  };

  String jsonObj = jsonEncode(obj);

  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/event"),
    headers: {'Authorization': token, 'Content-Type': 'application/json'},
    body: jsonObj
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> updateEvents(int eventId, String eventName, String description,
    String startDate, String endDate, int projectId) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;

  Map<String, dynamic> obj = {
    'eventName': eventName,
    'description': description,
    'startDate': startDate,
    'endDate': endDate,
    'projectId': projectId
  };

  String jsonObj = jsonEncode(obj);

  http.Response response = await http.post(
    Uri.parse("http://localhost:3000/api/event/update?evetId=$eventId&projectId=$projectId"),
    headers: {'Authorization': token, 'Content-Type': 'application/json'},
    body: jsonObj,
  );
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getApiAllEvents() async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/event/all-events"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> getEventsByProget(int id) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.get(
      Uri.parse("http://localhost:3000/api/event/my-events?projectId=$id"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}

Future<ApiResponse?> deleteEvents(int projectId, int eventId) async {
  String token =
      Credential.fromJson(jsonDecode(UserPreferences().userData)).token;
  http.Response response = await http.delete(
      Uri.parse("http://localhost:3000/api/event?projectId=$projectId&eventId=$eventId"),
      headers: {'Authorization': token});
  return ApiResponse.fromJson(jsonDecode(response.body));
}
