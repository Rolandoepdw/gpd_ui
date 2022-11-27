import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LeadEditProfileForm extends StatefulWidget {
  const LeadEditProfileForm({Key? key}) : super(key: key);

  @override
  State<LeadEditProfileForm> createState() => _LeadEditProfileFormState();
}

class _LeadEditProfileFormState extends State<LeadEditProfileForm> {
  final _formLoginKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserPreferences _userPreferences = UserPreferences();
  late Credential _credential;

  _LeadEditProfileFormState() {
    UserPreferences userPreferences = UserPreferences();
    _credential = credentialFromJson(userPreferences.userData);
    _nameController.text = _credential.displayname;
    _phoneController.text = '${_credential.phone}';
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    //Corregir q el singleChildScrollView se sale de la esquina del bottomSheet
    return SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultBorderRadius)),
          padding: const EdgeInsets.all(14),
          height: 483,
          width: 400,
          child: Form(
            key: _formLoginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildText(),
                const SizedBox(height: 20),
                _buildName(),
                _buildPhoneNumber(),
                _buildPassword(),
                _buildConfirmPassword(),
                const SizedBox(height: 20),
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
    return const Center(
        child: Text('Edit Profile',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
  }

  Widget _buildName() {
    return MyTextFormField.name(
      _nameController,
      'Nombre',
      40,
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'name'),
    );
  }

  Widget _buildPhoneNumber() {
    return MyTextFormField.name(
      _phoneController,
      'Phone',
      12,
      TextCapitalization.none,
      const TextInputType.numberWithOptions(decimal: false),
      false,
      (value) => validateInteger(value, 'phone'),
    );
  }

  Widget _buildPassword() {
    return MyTextFormField.name(
      _passwordController,
      'Password',
      25,
      TextCapitalization.words,
      TextInputType.name,
      true,
      (value) =>
          validatePasswordYConfirm(value, _confirmPasswordController.text),
    );
  }

  Widget _buildConfirmPassword() {
    return MyTextFormField.name(
      _confirmPasswordController,
      'Confirm password',
      25,
      TextCapitalization.words,
      TextInputType.name,
      true,
      (value) => validatePasswordYConfirm(value, _passwordController.text),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      height: 40,
      width: 85,
      child: ElevatedButton(
          onPressed: () async {
            if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await updateProfile(
                _credential.token,
                _nameController.text,
                _phoneController.text,
              );
              if(apiResponse!.statusCode == 1){
                _userPreferences.userData = credentialToJson(Credential(
                    token: _credential.token,
                    displayname: _nameController.text,
                    phone: _phoneController.text,
                    isAdmin: false));
              }
              Navigator.pop(context);

              await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(apiResponse.message[0],
                      textAlign: TextAlign.center),
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  dismissDirection: DismissDirection.endToStart,
                  duration: const Duration(seconds: 2)));
            }
          },
          child: const Text('Edit')),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: 40,
      width: 85,
      child: ElevatedButton(
          onPressed: () async {
            Navigator.pushNamed(context, 'leadHome');
          },
          child: const Text('Cancel')),
    );
  }
}
