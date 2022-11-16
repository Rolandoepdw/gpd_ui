import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/widgets/wrapper.dart';
import 'package:gpd/src/models/calendar_data.dart';

import 'package:flutter/material.dart';
import 'package:gpd/src/pages/admin/admin_components/admin_dashboard/components/list_calendar_data.dart';

class CalendartList extends StatelessWidget {
  final List<CalendarData> datas;

  const CalendartList({Key? key, required this.datas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: datas.isEmpty ? _Empty() : _List(list: datas),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No hay eventos.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<CalendarData> list;

  const _List({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🔥 Eventos del día", style: TextStyle(fontSize: 16)),
        SizedBox(
          height: defaultPadding,
        ),
        Wrapper(
          child: ListCalendarData(calendarData: list),
        ),
      ],
    );
  }
}
