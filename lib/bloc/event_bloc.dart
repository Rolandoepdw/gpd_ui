import 'dart:async';
import 'package:gpd/bloc/calendar_data_bloc.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/event.dart';
import 'package:gpd/src/provider/http_provider.dart';

class EventBloc {
  static final EventBloc _singleton = EventBloc._();

  factory EventBloc() => _singleton;

  EventBloc._();

  final _eventStreamController = StreamController<List<Event>>.broadcast();

  Stream<List<Event>> get stream => _eventStreamController.stream;

  dispose() {
    _eventStreamController.close();
  }

  Future<ApiResponse?> createNewEvent(String eventName, String description,
      String startDate, String endDate, int projectId) {
    CalendarDataBloc().getAllCalendarData(); //Refresh de CalendarWidget
    return createEvent(eventName, description, startDate, endDate, projectId);
  }

  Future<ApiResponse?> updateEvent(int eventId, String eventName, String description,
      String startDate, String endDate, int projectId) {
    CalendarDataBloc().getAllCalendarData(); //Refresh de CalendarWidget
    return updateEvents(
        eventId, eventName, description, startDate, endDate, projectId);
  }

  getAllEvens() async {
    ApiResponse? response = await getApiAllEvents();
    List<Event> list = [];
    if (response!.statusCode == 1) {
      list =
      List<Event>.from(response.data.map((event) => Event.fromJson(event)));
      _eventStreamController.sink.add(list);
    } else
      _eventStreamController.sink.add([]);
  }

  getEvenByProject(int id) async {
    ApiResponse? response = await getEventsByProget(id);
    List<Event> list = [];
    if (response!.statusCode == 1) {
      list =
          List<Event>.from(response.data.map((event) => Event.fromJson(event)));
      _eventStreamController.sink.add(list);
    } else
      _eventStreamController.sink.add([]);
  }

  Future<int> deleteEvent(int projectId, int eventId) async {
    ApiResponse? response = await deleteEvents(projectId, eventId);
    CalendarDataBloc().getAllCalendarData(); //Refresh de CalendarWidget
    return response!.statusCode;
  }
}
