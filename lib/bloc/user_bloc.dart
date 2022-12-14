import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/user.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'dart:async';

class UsersBloc {
  static final UsersBloc _singleton = UsersBloc._();

  factory UsersBloc() => _singleton;

  UsersBloc._();

  final _userStreamController = StreamController<List<User>>.broadcast();

  Stream<List<User>> get stream => _userStreamController.stream;

  dispose() {
    _userStreamController.close();
  }

  getAllWaitingUsers() async {
    ApiResponse? response = await getWaitingUsers();
    List<User> list = [];
    if (response!.statusCode == 1) {
      list = List<User>.from(
          response.data["formatedPeople"].map((user) => User.fromJson(user)));
      _userStreamController.sink.add(list);
    } else
      _userStreamController.sink.add([]);
  }

  Future<int> removeUser(int id) async {
    ApiResponse? response = await deleteUsers(id);
    if (response!.statusCode == 1) await this.getAllWaitingUsers();
    return response.statusCode;
  }

  Future<int> aceptUser(int id) async {
    ApiResponse? response = await aceptUsers(id);
    if (response!.statusCode == 1) await this.getAllWaitingUsers();
    return response.statusCode;
  }
}
