import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class ProjectsBloc {
  static final ProjectsBloc _singleton = ProjectsBloc._();

  factory ProjectsBloc() {
    return _singleton;
  }

  ProjectsBloc._();

  final _projectsStreamController = StreamController<List<Project>>.broadcast();

  Stream<List<Project>> get stream => _projectsStreamController.stream;

  dispose() {
    _projectsStreamController.close();
  }

  getActivatedProject() async {
    ApiResponse? response = await getProjects();
    List<Project> list = [];
    if (response!.statusCode == 1) {
      list = List<Project>.from(
          response.data.map((project) => Project.fromJson(project)));
      list.removeWhere((element) => element.state == 'WAITING');
      _projectsStreamController.sink.add(list);
    } else
      _projectsStreamController.sink.add([]);
  }

  Future<int> removeProject(int id) async {
    ApiResponse? response = await deleteProjects(id);

    if (response!.statusCode == 1) await this.getActivatedProject();

    return response.statusCode;
  }

  Future<int> aceptProject(int id) async {
    ApiResponse? response = await aceptProjects(id);

    if (response!.statusCode == 1) await this.getActivatedProject();

    return response.statusCode;
  }
}
