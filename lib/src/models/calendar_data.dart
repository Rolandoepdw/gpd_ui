import 'package:intl/intl.dart';

class CalendarData {
  String eventName;
  String description;
  DateTime startDate;
  DateTime endDate;

  CalendarData(
      {required this.eventName,
      required this.description,
      required this.startDate,
      required this.endDate});

  factory CalendarData.fromJson(Map<String, dynamic> json) => CalendarData(
    eventName: json["eventName"],
    description: json["description"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
  );

  String getStartDate() {
    final formatter = DateFormat('kk:mm');
    return formatter.format(startDate);
  }

  String getEndDate() {
    final formatter = DateFormat('kk:mm');
    return formatter.format(endDate);
  }
}

List<CalendarData> calendarData = [
  // CalendarData(
  //   name: 'Deniz Çolak',
  //   date: DateTime.now().add(Duration(days: -16, hours: 5)),
  //   position: "Software Architect",
  //   rating: '4',
  // ),
  // CalendarData(
  //   name: 'John Doe',
  //   date: DateTime.now().add(Duration(days: -5, hours: 8)),
  //   position: "Software Engineer",
  //   rating: '3',
  // ),
  // CalendarData(
  //   name: 'Joy Barker',
  //   date: DateTime.now().add(Duration(days: -10, hours: 3)),
  //   position: "Solution Architect",
  //   rating: '\$',
  // ),
  // CalendarData(
  //   name: 'Kate Hartley',
  //   date: DateTime.now().add(Duration(days: 6, hours: 6)),
  //   position: "Project Manager",
  //   rating: '\$',
  // ),
  // CalendarData(
  //   name: 'Fletcher Robson',
  //   date: DateTime.now().add(Duration(days: -18, hours: 9)),
  //   position: "Line Manager",
  //   rating: '\$',
  // ),
  // CalendarData(
  //   name: 'Aldrich Mason',
  //   date: DateTime.now().add(Duration(days: -12, hours: 2)),
  //   position: "UI/UX Designer",
  //   rating: '\$',
  // ),
  // CalendarData(
  //   name: 'Phyllis Leonard',
  //   date: DateTime.now().add(Duration(days: -8, hours: 4)),
  //   position: "Business Analyst",
  //   rating: '\$',
  // ),
  // CalendarData(
  //   name: 'Ken Rehbein',
  //   date: DateTime.now().add(Duration(days: -3, hours: 6)),
  //   position: "Software Architect",
  //   rating: '₽',
  // ),
  // CalendarData(
  //   name: 'Sydney Blake',
  //   date: DateTime.now().add(Duration(days: -2, hours: 6)),
  //   position: "Project Manager",
  //   rating: '₽',
  // ),
  // CalendarData(
  //   name: 'Megan Salazar',
  //   date: DateTime.now().add(Duration(days: -2, hours: 7)),
  //   position: "Software Engineer",
  //   rating: '₽',
  // ),
  // CalendarData(
  //   name: 'Celeste Pena',
  //   date: DateTime.now().add(Duration(days: -14, hours: 5)),
  //   position: "Solution Architect",
  //   rating: '₽',
  // ),
];
