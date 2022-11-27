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

  final _clientsStreamController = StreamController<List<User>>.broadcast();

  Stream<List<User>> get stream => _clientsStreamController.stream;

  dispose() {
    _clientsStreamController.close();
  }

  getWatingUsers() async {
    ApiResponse? response = await getAwaitingUsers();
    List<User> list = [];
    if (response!.statusCode == 1) {
      list = List<User>.from(
          response.data["formatedPeople"].map((user) => User.fromJson(user)));
      _clientsStreamController.sink.add(list);
    } else
      _clientsStreamController.sink.add([]);
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
