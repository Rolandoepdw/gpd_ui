import 'dart:async';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/calendar_data.dart';
import 'package:gpd/src/provider/http_provider.dart';

class CalendarDataBloc {
  static final CalendarDataBloc _singleton = CalendarDataBloc._();

  factory CalendarDataBloc() => _singleton;

  CalendarDataBloc._();

  final _calendarDataStreamController =
      StreamController<List<CalendarData>>.broadcast();

  Stream<List<CalendarData>> get stream => _calendarDataStreamController.stream;

  dispose() {
    _calendarDataStreamController.close();
  }

  getAllCalendarData() async {
    ApiResponse? response = await getApiAllEvents();
    List<CalendarData> list = [];
    if (response!.statusCode == 1) {
      list = List<CalendarData>.from(response.data
          .map((calendarData) => CalendarData.fromJson(calendarData)));
      _calendarDataStreamController.sink.add(list);
    } else
      _calendarDataStreamController.sink.add([]);
  }
}
