import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/elegent_notification_manager.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formLoginKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserPreferences _userPreferences = UserPreferences();
  late Credential _credential;

  _EditProfileFormState() {
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius)),
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
                    _buildEditButton(context),
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
        child: Text('Editar perfil',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
  }

  Widget _buildName() {
    return MyTextFormField.name(
      _nameController,
      'Nombre',
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'nombre'),
    );
  }

  Widget _buildPhoneNumber() {
    return MyTextFormField.name(
      _phoneController,
      'Teléfono',
      TextCapitalization.none,
      const TextInputType.numberWithOptions(decimal: false),
      false,
      (value) => validateInteger(value, 'teléfono'),
    );
  }

  Widget _buildPassword() {
    return MyTextFormField.name(
      _passwordController,
      'Contraseña',
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
      'Confirmar contraseña',
      TextCapitalization.words,
      TextInputType.name,
      true,
      (value) => validatePasswordYConfirm(value, _passwordController.text),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Container(
      height: 40,
      width: 85,
      child: ElevatedButton(
          onPressed: () async {
            if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await updateProfile(
                  _nameController.text,
                  _phoneController.text,
                  _passwordController.text);
              if (apiResponse!.statusCode == 1) {
                _userPreferences.userData = credentialToJson(Credential(
                    token: _credential.token,
                    displayname: _nameController.text,
                    phone: _phoneController.text,
                    isAdmin: false));
              }

              Navigator.pop(context);

              await SuccessNotification(
                  context, 'Perfil editado correctamente');
            }
          },
          child: const Text('Editar')),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: 40,
      width: 85,
      child: ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Cancelar')),
    );
  }
}

Future<void> buildEditBottomSheet(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const EditProfileForm();
    },
    constraints: BoxConstraints(
        maxWidth: size.width * 0.4,
        minWidth: size.width * 0.4,
        maxHeight: 443,
        minHeight: 443),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(defaultBorderRadius),
        topRight: Radius.circular(defaultBorderRadius),
      ),
    ),
  );
}
