import 'package:flutter/material.dart';
import 'package:gpd/bloc/event_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/date_utils.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/elegent_notification_manager.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/event.dart';
import 'package:gpd/src/models/project.dart';

class LeadEditEventForm extends StatefulWidget {
  Project _project;
  Event _event;

  LeadEditEventForm(this._project, this._event);

  @override
  State<LeadEditEventForm> createState() =>
      _LeadEditEventFormState(_project, _event);
}

class _LeadEditEventFormState extends State<LeadEditEventForm> {
  final _formLoginKey = GlobalKey<FormState>();

  late final _eventName;
  late final _description;
  DateTime? _startDate;
  DateTime? _endDate;

  late String _textStartDate;
  late String _textEndDate;

  Project project;
  Event event;

  _LeadEditEventFormState(this.project, this.event) {
    _eventName = TextEditingController()..text = event.eventName;
    _description = TextEditingController()..text = event.description;
    _startDate = event.startDate;
    _endDate = event.endDate;
    _textStartDate = longDate(event.startDate);
    _textEndDate = longDate(event.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formLoginKey,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(defaultBorderRadius)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildText(),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        child: _buildEventName(),
                      ),
                      Container(
                        width: 220,
                        child: _buildDescription(),
                      ),
                    ]),
                _buildDateRangePiker(context),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCreateButton(context),
                    _buildCancelButton(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Center(
        child: Text('Editar evento',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
  }

  Widget _buildEventName() {
    return MyTextFormField.name(
      _eventName,
      'Nombre del evento',
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'nombre'),
    );
  }

  Widget _buildDescription() {
    return MyTextFormField.name(
      _description,
      'Descripción',
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'descripción'),
    );
  }

  Widget _buildDateRangePiker(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  child: Text(_textStartDate),
                  onPressed: () {
                    pickStartDate(context);
                  })),
          SizedBox(width: 56),
          Container(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  child: Text(_textEndDate),
                  onPressed: () {
                    pickEndDate(context);
                  }))
        ]));
  }

  Future pickStartDate(BuildContext context) async {
    DateTime? startDate = await showDatePicker(
        context: context,
        firstDate: (project.startDate.isAfter(DateTime.now())
            ? project.startDate
            : DateTime.now()),
        lastDate: (project.endDate.isAfter(DateTime.now())
            ? project.endDate
            : DateTime.now()),
        initialDate: (project.startDate.isAfter(DateTime.now())
            ? project.startDate
            : DateTime.now()),
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (startDate == null) return;

    TimeOfDay? startTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (startTime == null) return;

    setState(() {
      _startDate = DateTime(startDate.year, startDate.month, startDate.day,
          startTime.hour, startTime.minute);
      _textStartDate = longDate(_startDate!);
    });
  }

  Future pickEndDate(BuildContext context) async {
    DateTime? endDate = await showDatePicker(
        context: context,
        firstDate: (project.startDate.isAfter(DateTime.now())
            ? project.startDate
            : DateTime.now()),
        lastDate: (project.endDate.isAfter(DateTime.now())
            ? project.endDate
            : DateTime.now()),
        initialDate: (project.startDate.isAfter(DateTime.now())
            ? project.startDate
            : DateTime.now()),
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (endDate == null) return;

    TimeOfDay? endTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (endTime == null) return;

    setState(() {
      _endDate = DateTime(endDate.year, endDate.month, endDate.day,
          endTime.hour, endTime.minute);
      _textEndDate = longDate(_endDate!);
    });
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      height: 40,
      width: 90,
      child: ElevatedButton(
          onPressed: () async {
            if (_startDate == null) {
              await ErrorNotification(context, 'Seleccione la fecha inicial');
            } else if (_endDate == null) {
              await ErrorNotification(context, 'Seleccione la fecha final');
            } else if (_endDate!.isBefore(_startDate!)) {
              await ErrorNotification(
                  context, 'La fecha final debe ser posterior a la inicial');
            } else if (_formLoginKey.currentState!.validate()) {
              await EventBloc().updateEvent(
                event.id,
                _eventName.text,
                _description.text,
                _startDate!.toIso8601String(),
                _endDate!.toIso8601String(),
                project.id,
              );

              Navigator.of(context).pop();

              await SuccessNotification(
                  context, 'Evento actualizado correctamente');
            }
          },
          child: Text('Editar')),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
        height: 40,
        width: 90,
        child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')));
  }
}
