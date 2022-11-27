import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/full_user.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class UsersBloc {
  static final UsersBloc _singleton = UsersBloc._();

  factory UsersBloc() {
    return _singleton;
  }

  UsersBloc._();

  final _usersStreamController = StreamController<List<FullUser>>.broadcast();

  Stream<List<FullUser>> get stream => _usersStreamController.stream;

  dispose() {
    _usersStreamController.close();
  }

  getActivatedUsers() async {
    ApiResponse? response = await getUsers();
    List<FullUser> list = [];
    if (response!.statusCode == 1) {
      list = List<FullUser>.from(
          response.data["formatedPeople"].map((user) => FullUser.fromJson(user)));
      list.removeWhere((element) => element.state == 'WAITING');
      _usersStreamController.sink.add(list);
    } else
      _usersStreamController.sink.add([]);
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
