import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpd/core/utils/inputs_validation_functions.dart';
import 'package:gpd/core/widgets/my_text_form_field.dart';
import 'package:gpd/src/models/apiResponse.dart';
import 'package:gpd/src/models/credential.dart';
import 'package:gpd/src/provider/http_provider.dart';
import 'package:gpd/src/user_preferences/user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userPreferences = UserPreferences();
  late ApiResponse apiResponse;

  @override
  Widget build(BuildContext context) {
    if (_userPreferences.userData != 'userPreferences error') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Credential credential =
            Credential.fromJson(jsonDecode(_userPreferences.userData));
        if (credential.isAdmin)
          Navigator.pushNamed(context, 'adminHomePage');
        else
          Navigator.pushNamed(context, 'waiting');
      });
    }
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
            height: 400,
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildText(),
                SizedBox(height: 20),
                _buildUser(),
                _buildPassword(),
                SizedBox(height: 20),
                _buildLoginButton(context),
                SizedBox(height: 20),
                _buildAccauntOption(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Center(
        child: Text('Bienvenido a GPD',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)));
  }

  Widget _buildUser() {
    return MyTextFormField.name(
      _userController,
      'Usuario',
      TextCapitalization.words,
      TextInputType.name,
      false,
      (value) => validateInteger(value, 'phone'),
    );
  }

  Widget _buildPassword() {
    return MyTextFormField.name(
      _passwordController,
      'Contraseña',
      TextCapitalization.words,
      TextInputType.name,
      true,
      (value) => validatePassword(value),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      height: 40,
      child: ElevatedButton(
          onPressed: () async {
            if (_formLoginKey.currentState!.validate()) {
              ApiResponse? apiResponse =
                  await signIn(_userController.text, _passwordController.text);

              if (apiResponse!.statusCode == 1) {
                Credential credential = Credential.fromJson(apiResponse.data);
                if (credential.isAdmin)
                  Navigator.pushNamed(context, 'adminHome');
                else
                  Navigator.pushNamed(context, 'leadHome');
              }

              print(apiResponse.statusCode);

              if (apiResponse.statusCode != 1)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(apiResponse.message[0],
                        textAlign: TextAlign.center),
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    dismissDirection: DismissDirection.endToStart,
                    duration: Duration(seconds: 2)));
            }
          },
          child: Text('Acceder')),
    );
  }

  Widget _buildAccauntOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'createAccount');
            },
            child: Text("¿No tienes cuenta?")),
        TextButton(onPressed: () {}, child: Text("¿Olvidaste la contraseña?"))
      ],
    );
  }
}
