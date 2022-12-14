import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:gpd/bloc/event_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/date_utils.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/project.dart';

class LeadNewEventForm extends StatefulWidget {
  Project _project;

  LeadNewEventForm(this._project, {Key? key}) : super(key: key);

  @override
  State<LeadNewEventForm> createState() => _LeadNewEventFormState();
}

class _LeadNewEventFormState extends State<LeadNewEventForm> {
  final _formLoginKey = GlobalKey<FormState>();
  final _eventName = TextEditingController();
  final _description = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _textStartDate = 'Fecha inicial';
  String _textEndDate = 'Fecha final';

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
            padding: EdgeInsets.all(20),
            width: 500,
            height: 600,
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
                        child: _buildArea(),
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
        child: Text('Crear evento',
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

  Widget _buildArea() {
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
        firstDate: (widget._project.startDate.isAfter(DateTime.now())
            ? widget._project.startDate
            : DateTime.now()),
        lastDate: (widget._project.endDate.isAfter(DateTime.now())
            ? widget._project.endDate
            : DateTime.now()),
        initialDate: (widget._project.startDate.isAfter(DateTime.now())
            ? widget._project.startDate
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
        firstDate: (widget._project.startDate.isAfter(DateTime.now())
            ? widget._project.startDate
            : DateTime.now()),
        lastDate: (widget._project.endDate.isAfter(DateTime.now())
            ? widget._project.endDate
            : DateTime.now()),
        initialDate: (widget._project.startDate.isAfter(DateTime.now())
            ? widget._project.startDate
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
              ElegantNotification.error(
                  title: Text("Error"),
                  width: 300,
                  background: secondaryColor,
                  description: Text('Seleccione la fecha inicial'))
                  .show(context);
            } else if (_endDate == null) {
              ElegantNotification.error(
                  title: Text("Error"),
                  width: 300,
                  background: secondaryColor,
                  description: Text('Seleccione la fecha final'))
                  .show(context);
            } else if (_endDate!.isBefore(_startDate!)) {
              ElegantNotification.error(
                  title: Text("Error"),
                  width: 300,
                  background: secondaryColor,
                  description: Text('La fecha final debe ser posterior a la inicial'))
                  .show(context);
            } else if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await EventBloc().createNewEvent(
                  _eventName.text,
                  _description.text,
                  _startDate!.toIso8601String(),
                  _endDate!.toIso8601String(),
                  widget._project.id);

              print(apiResponse!.message);

              Navigator.of(context).pop();

              ElegantNotification.success(
                  title: Text("Nuevo"),
                  width: 300,
                  background: secondaryColor,
                  description: Text(apiResponse.message[0]))
                  .show(context);
            }
          },
          child: Text('Crear')),
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
