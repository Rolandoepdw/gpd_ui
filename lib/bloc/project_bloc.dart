import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class ProjectBloc {
  static final ProjectBloc _singleton = ProjectBloc._();

  factory ProjectBloc() {
    return _singleton;
  }

  ProjectBloc._();

  final _projectStreamController = StreamController<List<Project>>.broadcast();

  Stream<List<Project>> get stream => _projectStreamController.stream;

  dispose() {
    _projectStreamController.close();
  }

  Future<ApiResponse?> createNewProject(
      String projectName,
      String area,
      String startDate,
      String endDate,
      String justification,
      String recomendations) {
    return createProject(
        projectName, area, startDate, endDate, justification, recomendations);
  }

  Future<ApiResponse?> updateProject(
      int id,
      String projectName,
      String area,
      String startDate,
      String endDate,
      String justification,
      String recomendations) {
    return updateProjects(id, projectName, area, startDate, endDate,
        justification, recomendations);
  }

  getWatingProjects() async {
    ApiResponse? response = await getProjects();
    List<Project> list = [];
    if (response!.statusCode == 1) {
      list = List<Project>.from(
          response.data.map((project) => Project.fromJson(project)));
      list.removeWhere((element) => element.state != 'WAITING');
      _projectStreamController.sink.add(list);
    } else
      _projectStreamController.sink.add([]);
  }

  getActivatedProject() async {
    ApiResponse? response = await getProjects();
    List<Project> list = [];
    if (response!.statusCode == 1) {
      list = List<Project>.from(
          response.data.map((project) => Project.fromJson(project)));
      list.removeWhere((element) => element.state == 'WAITING');
      _projectStreamController.sink.add(list);
    } else
      _projectStreamController.sink.add([]);
  }

  getMyWatingProjects() async {
    ApiResponse? response = await getMyProjects();
    List<Project> list = [];
    if (response!.statusCode == 1) {
      list = List<Project>.from(
          response.data.map((project) => Project.fromJson(project)));
      list.removeWhere((element) => element.state != 'WAITING');
      _projectStreamController.sink.add(list);
    } else
      _projectStreamController.sink.add([]);
  }

  getMyActivatedProjects() async {
    ApiResponse? response = await getMyProjects();
    List<Project> list = [];
    if (response!.statusCode == 1) {
      list = List<Project>.from(
          response.data.map((project) => Project.fromJson(project)));
      list.removeWhere((element) => element.state == 'WAITING');
      _projectStreamController.sink.add(list);
    } else
      _projectStreamController.sink.add([]);
  }

  Future<int> deleteProject(int id) async {
    ApiResponse? response = await deleteProjects(id);
    return response!.statusCode;
  }

  Future<int> aceptProject(int id) async {
    ApiResponse? response = await aceptProjects(id);
    return response!.statusCode;
  }
}
