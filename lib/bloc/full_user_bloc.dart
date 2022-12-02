import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class FullUserBloc {
  static final FullUserBloc _singleton = FullUserBloc._();

  factory FullUserBloc() {
    return _singleton;
  }

  FullUserBloc._();

  final _fullUserStreamController = StreamController<List<FullUser>>.broadcast();

  Stream<List<FullUser>> get stream => _fullUserStreamController.stream;

  dispose() {
    _fullUserStreamController.close();
  }

  getActivatedUsers() async {
    ApiResponse? response = await getUsers();
    List<FullUser> list = [];
    if (response!.statusCode == 1) {
      list = List<FullUser>.from(
          response.data["formatedPeople"].map((user) => FullUser.fromJson(user)));
      list.removeWhere((element) => element.state == 'WAITING');
      _fullUserStreamController.sink.add(list);
    } else
      _fullUserStreamController.sink.add([]);
  }

  Future<int> removeUser(int id) async {
    ApiResponse? response = await deleteUsers(id);
    if (response!.statusCode == 1) await this.getActivatedUsers();
    return response.statusCode;
  }

  Future<int> aceptUser(int id) async {
    ApiResponse? response = await aceptUsers(id);
    if (response!.statusCode == 1) await this.getActivatedUsers();
    return response.statusCode;
  }
}
