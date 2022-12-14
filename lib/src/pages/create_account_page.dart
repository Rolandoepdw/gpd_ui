import 'package:flutter/material.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/elegent_notification_manager.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class CreateAccauntPage extends StatefulWidget {
  const CreateAccauntPage({Key? key}) : super(key: key);

  @override
  State<CreateAccauntPage> createState() => _CreateAccauntPageState();
}

class _CreateAccauntPageState extends State<CreateAccauntPage> {
  final _formLoginKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final userPreferences = UserPreferences();
  late ApiResponse apiResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formLoginKey,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 515,
            width: 400,
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
                _buildCreateButton(context),
                const SizedBox(height: 20),
                _buildGoBack(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return const Center(
        child: Text('Crear cuenta',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)));
  }

  Widget _buildName() {
    return MyTextFormField.name(
      _nameController,
      'Nombre',
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateName(value, 'name'),
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

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      height: 40,
      child: ElevatedButton(
          onPressed: () async {
            if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse = await signUp(_nameController.text,
                  _phoneController.text, _passwordController.text);

              Navigator.pushNamed(context, 'login');

              print(apiResponse!.statusCode);

              if (apiResponse.statusCode == 1) {
                await InfoNotification(context, 'Proceso iniciado');
              }

              if (apiResponse.statusCode == 21)
                await ErrorNotification(context, 'La persona ya ha sido registrada');
            }
          },
          child: const Text('Crear')),
    );
  }

  Widget _buildGoBack(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
            child: const Text("¿Ya tienes cuenta?")),
      ],
    );
  }
}
