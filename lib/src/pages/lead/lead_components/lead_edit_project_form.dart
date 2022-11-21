import 'package:flutter/material.dart';
import 'package:gpd/core/utils/date_utils.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/my_text_area_form_field.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/models/project.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadEditProjectForm extends StatefulWidget {
  Project _project;
  Function _callBack;

  LeadEditProjectForm(this._project, this._callBack, {Key? key}) : super(key: key);

  @override
  State<LeadEditProjectForm> createState() =>
      _LeadEditProjectFormState(_project, _callBack);
}

class _LeadEditProjectFormState extends State<LeadEditProjectForm> {
  final _formLoginKey = GlobalKey<FormState>();
  late final Project _project;
  late final _callBack;
  late final _projectName;
  late final _area;
  late final _justification;
  late final _recomendations;
  late Credential _credential;
  late DateTimeRange _dateTimeRange;
  late String _startDate;
  late String _endDate;

  _LeadEditProjectFormState(this._project, this._callBack) {
    UserPreferences userPreferences = UserPreferences();
    _credential = credentialFromJson(userPreferences.userData);
    _projectName = TextEditingController()..text = _project.projectName;
    _area = TextEditingController()..text = _project.area;
    _justification = TextEditingController()
      ..text = _project.justification ?? '';
    _recomendations = TextEditingController()
      ..text = _project.recomendations ?? '';
    _dateTimeRange =
        DateTimeRange(start: _project.startDate, end: _project.endDate);
    _startDate = shortDate(_dateTimeRange.start);
    _endDate = shortDate(_dateTimeRange.end);
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
            padding: EdgeInsets.all(20),
            width: 600,
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
                        child: _buildProjectName(),
                      ),
                      Container(
                        width: 220,
                        child: _buildArea(),
                      ),
                    ]),
                _buildDateRangePiker(context),
                _buildJustification(),
                _buildRecomendation(),
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
        child: Text('Crear proyecto',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
  }

  Widget _buildProjectName() {
    return MyTextFormField.name(
      _projectName,
      'Nombre del proyecto',
      40,
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'nombre'),
    );
  }

  Widget _buildArea() {
    return MyTextFormField.name(
      _area,
      'Area',
      40,
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'area'),
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
                  child: Text(_startDate),
                  onPressed: () {
                    pickDateRange(context);
                  })),
          SizedBox(width: 56),
          Container(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  child: Text(_endDate),
                  onPressed: () {
                    pickDateRange(context);
                  }))
        ]));
  }

  Future pickDateRange(BuildContext context) async {
    DateTimeRange? newDateTimeRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        initialDateRange: _dateTimeRange,
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (newDateTimeRange == null) return; // Press X

    setState(() {
      _dateTimeRange = newDateTimeRange;
      _startDate = shortDate(_dateTimeRange.start);
      _endDate = shortDate(_dateTimeRange.end);
    }); // Press Save
  }

  Widget _buildJustification() {
    return MyTextAreaFormField.name(
      _justification,
      'Justificación',
      500,
      3,
      3,
      TextCapitalization.words,
      false,
      (value) => validateText(value, 'text'),
    );
  }

  Widget _buildRecomendation() {
    return MyTextAreaFormField.name(
      _recomendations,
      'Recomendaciones',
      500,
      4,
      4,
      TextCapitalization.words,
      false,
      (value) => validateText(value, 'text'),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      height: 40,
      width: 90,
      child: ElevatedButton(
          onPressed: () async {
            if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await updateProject(
                _credential.token,
                widget._project.id,
                _projectName.text,
                _area.text,
                _dateTimeRange.start.toIso8601String(),
                _dateTimeRange.end.toIso8601String(),
                _justification.text,
                _recomendations.text,
              );

              _callBack();
              Navigator.pop(context);

              await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(apiResponse!.message[0],
                      textAlign: TextAlign.center),
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  dismissDirection: DismissDirection.endToStart,
                  duration: Duration(seconds: 2)));
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
              Navigator.pop(context);
            },
            child: Text('Cancelar')));
  }
}