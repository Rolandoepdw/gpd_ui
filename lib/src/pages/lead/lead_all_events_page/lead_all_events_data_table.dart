import 'package:gpd/bloc/event_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/src/models/event.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/core/utils/date_utils.dart';

class LeadAllEventsDataTable extends StatefulWidget {
  @override
  State<LeadAllEventsDataTable> createState() => _LeadAllEventsDataTableState();
}

class _LeadAllEventsDataTableState extends State<LeadAllEventsDataTable> {
  @override
  Widget build(BuildContext context) {
    EventBloc().getAllEvens();

    return Container(
        height: 400,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Eventos',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Divider(),
          SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<Event>>(
                  stream: EventBloc().stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return DataTable(
                        horizontalMargin: 2,
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(label: Text("Nombre")),
                          // DataColumn(label: Text("Descripción")),
                          DataColumn(label: Text("Fecha inicial")),
                          DataColumn(label: Text("Fecha final")),
                        ],
                        rows: List.generate(
                            snapshot.data!.length,
                            (index) => waitingUserDataRow(
                                context, snapshot.data![index])));
                  }))
        ])));
  }

  DataRow waitingUserDataRow(BuildContext context, Event eventInfo) {
    return DataRow(cells: [
      // projectName
      DataCell(Row(children: [
        TextAvatar(
          size: 35,
          backgroundColor: Colors.white,
          textColor: Colors.white,
          fontSize: 14,
          upperCase: true,
          numberLetters: 1,
          shape: Shape.Rectangle,
          text: eventInfo.eventName,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(eventInfo.eventName,
                maxLines: 1, overflow: TextOverflow.ellipsis))
      ])),
      // DataCell(Text(
      //   eventInfo.description,
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      // )),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: getRoleColor('').withOpacity(.2),
              border: Border.all(color: getRoleColor('')),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(shortDate(eventInfo.startDate)))),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor('').withOpacity(.2),
            border: Border.all(color: getRoleColor('')),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(shortDate(eventInfo.endDate))))
    ]);
  }
}
