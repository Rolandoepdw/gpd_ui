import 'package:gpd/bloc/event_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/colorful_tag.dart';
import 'package:gpd/core/widgets/my_alert.dart';
import 'package:gpd/src/models/event.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gpd/core/utils/date_utils.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/pages/lead/lead_components/lead_edit_event_form.dart';
import 'package:gpd/src/pages/lead/lead_components/lead_new_event_form.dart';

class LeadEventsByProjectDataTable extends StatefulWidget {
  Project _project;

  LeadEventsByProjectDataTable(this._project);

  @override
  State<LeadEventsByProjectDataTable> createState() =>
      _LeadEventsByProjectDataTableState();
}

class _LeadEventsByProjectDataTableState
    extends State<LeadEventsByProjectDataTable> {
  @override
  Widget build(BuildContext context) {
    EventBloc().getEvenByProject(widget._project.id);

    return Column(children: [
      _buildProjectCard(),
      SizedBox(height: defaultPadding),
      Container(
          height: 400,
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Eventos',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        '${shortDate(widget._project.startDate)} - ${shortDate(widget._project.endDate)}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ElevatedButton(
                          child: Text('Nuevo'),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LeadNewEventForm(widget._project)));
                            await EventBloc().getEvenByProject(widget._project.id);
                          })
                    ]),
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
                                DataColumn(label: Text("Fecha inicial")),
                                DataColumn(label: Text("Fecha final")),
                                DataColumn(label: Text("Opciones"))
                              ],
                              rows: List.generate(
                                snapshot.data!.length,
                                (index) => waitingUserDataRow(
                                    context, snapshot.data![index]),
                              ));
                        }))
              ])))
    ]);
  }

  Widget _buildProjectCard() {
    return Container(
        // height: 200,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: SingleChildScrollView(
            child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextAvatar(
              size: 60,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 28,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: widget._project.projectName,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 5),
                      child: Text('Nombre:  ${widget._project.projectName}',
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 5),
                      child: Text('Área:  ${widget._project.area}',
                          maxLines: 1, overflow: TextOverflow.ellipsis))
                ])
          ]),
          Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(children: [
                      Text('Justificación'),
                      Divider(),
                      Text('${widget._project.justification}',
                          textAlign: TextAlign.left)
                    ])),
                    SizedBox(width: defaultPadding),
                    Expanded(
                        child: Column(children: [
                      Text('Recomendaciones'),
                      Divider(),
                      Text('${widget._project.recomendations}',
                          textAlign: TextAlign.left)
                    ]))
                  ]))
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
            text: eventInfo.eventName),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(eventInfo.eventName,
                maxLines: 1, overflow: TextOverflow.ellipsis))
      ])),
      // DataCell(Text(eventInfo.description)),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: getRoleColor('').withOpacity(.2),
              border: Border.all(color: getRoleColor('')),
              borderRadius: BorderRadius.all(Radius.circular(5.0) //
                  )),
          child: Text(longDate(eventInfo.startDate)))),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: getRoleColor('').withOpacity(.2),
              border: Border.all(color: getRoleColor('')),
              borderRadius: BorderRadius.all(Radius.circular(5.0) //
                  )),
          child: Text(longDate(eventInfo.endDate)))),
      DataCell(Row(children: [
        TextButton(
            child: Text('Editar', style: TextStyle(color: primaryColor)),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LeadEditEventForm(widget._project, eventInfo)));
              await EventBloc().getEvenByProject(widget._project.id);
              setState(() {});
            }),
        SizedBox(
          width: 6,
        ),
        TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
            onPressed: () {
              showMyDialog(
                  context: context,
                  icon: Icon(Icons.delete_forever_outlined,
                      size: 36, color: Colors.red),
                  toDoText: '¿Eliminar a ${eventInfo.eventName}?',
                  actions: [
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.close,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: Text("Cancelar")),
                    ElevatedButton.icon(
                        icon: Icon(
                          Icons.delete,
                          size: 14,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          await EventBloc().deleteEvent(widget._project.id, eventInfo.id);
                          await EventBloc()
                              .getEvenByProject(widget._project.id);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        label: Text("Eliminar"))
                  ]);
            })
      ]))
    ]);
  }
}
