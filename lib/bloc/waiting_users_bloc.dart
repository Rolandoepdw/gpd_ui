import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/user.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class WaitingUsersBloc {
  static final WaitingUsersBloc _singleton = WaitingUsersBloc._();

  factory WaitingUsersBloc() {
    return _singleton;
  }

  WaitingUsersBloc._();

  final _usersUsersStreamController = StreamController<List<User>>.broadcast();

  Stream<List<User>> get stream => _usersUsersStreamController.stream;

  dispose() {
    _usersUsersStreamController.close();
  }

  getWatingUsers() async {
    ApiResponse? response = await getAwaitingUsers();
    List<User> list = [];
    if (response!.statusCode == 1) {
      list = List<User>.from(
          response.data["formatedPeople"].map((user) => User.fromJson(user)));
      _usersUsersStreamController.sink.add(list);
    } else
      _usersUsersStreamController.sink.add([]);
  }

  Future<int> removeUser(int id) async {
    ApiResponse? response = await deleteUsers(id);
    if (response!.statusCode == 1) await this.getWatingUsers();
    return response.statusCode;
  }

  Future<int> aceptUser(int id) async {
    ApiResponse? response = await aceptUsers(id);
    if (response!.statusCode == 1) await this.getWatingUsers();
    return response.statusCode;
  }
}
