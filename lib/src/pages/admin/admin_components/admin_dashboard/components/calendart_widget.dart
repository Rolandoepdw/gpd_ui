import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/src/models/calendar_data.dart';

import 'package:flutter/material.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_dashboard/components/calendar_list_widget.dart';


import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<CalendarData> _selectedDate = [];

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<CalendarData> _eventLoader(DateTime date) {
    return calendarData
        .where((element) => isSameDay(date, element.date))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDate = calendarData
            .where((element) => isSameDay(selectedDay, element.date))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${DateFormat("d  MMM  yyyy").format(_focusedDay)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: greenColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        print(_focusedDay);
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                    child: Icon(
                      Icons.chevron_right,
                      color: greenColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: defaultPadding),
          TableCalendar<CalendarData>(
              selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2022),
              lastDay: DateTime.utc(2050),
              headerVisible: false,
              onDaySelected: _onDaySelected,
              onFormatChanged: (result) {},
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (date, locale) {
                  return DateFormat("EEE").format(date).toUpperCase();
                },
                weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPageChanged: (day) {
                _focusedDay = day;
                setState(() {});
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: greenColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: greenColor,
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: _eventLoader),
          SizedBox(height: defaultPadding),
          CalendartList(datas: _selectedDate),
        ],
      ),
    );
  }
}
