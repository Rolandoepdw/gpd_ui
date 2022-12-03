import 'package:flutter/material.dart';
import 'package:gpd/bloc/project_bloc.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/date_utils.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/my_text_area_form_field.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';

class LeadNewProjectForm extends StatefulWidget {
  const LeadNewProjectForm({Key? key}) : super(key: key);

  @override
  State<LeadNewProjectForm> createState() => _LeadNewProjectFormState();
}

class _LeadNewProjectFormState extends State<LeadNewProjectForm> {
  final _formLoginKey = GlobalKey<FormState>();
  final _projectName = TextEditingController();
  final _area = TextEditingController();
  final _justification = TextEditingController();
  final _recomendations = TextEditingController();
  late DateTimeRange _dateTimeRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  String _startDate = 'Fecha inicial';
  String _endDate = 'Fecha final';

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
        builder: (context, child) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      color: bgColor),
                  width: 450,
                  height: 480,
                  child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: child)),
            ),
          );
        },
        firstDate: DateTime.now().add(Duration(days: -1)),
        lastDate: DateTime(2025),
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
            if (_dateTimeRange.start == null) {
              await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Seleccione las fechas',
                      textAlign: TextAlign.center),
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  dismissDirection: DismissDirection.endToStart,
                  duration: Duration(seconds: 2)));
            } else if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await ProjectBloc().createNewProject(
                _projectName.text,
                _area.text,
                _dateTimeRange.start.toIso8601String(),
                _dateTimeRange.end.toIso8601String(),
                _justification.text,
                _recomendations.text,
              );

              Navigator.pushNamed(context, 'leadProjects');

              await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(apiResponse!.message[0],
                      textAlign: TextAlign.center),
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  dismissDirection: DismissDirection.endToStart,
                  duration: Duration(seconds: 2)));
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
              Navigator.pushNamed(context, 'leadProjects');
            },
            child: Text('Cancelar')));
  }
}
