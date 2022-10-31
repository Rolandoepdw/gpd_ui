import 'package:flutter/material.dart';
import 'package:gpd/src/my_widgets/my_input_decoration.dart';

class MyTextFormField extends StatelessWidget {
  TextEditingController _controller;
  String _label;
  int _maxLength;
  TextCapitalization _textCapitalization;
  TextInputType _keyboardType;
  bool _obscureText;
  String? Function(String?) _validator;

  MyTextFormField.name(this._controller, this._label, this._maxLength,
      this._textCapitalization, this._keyboardType, this._obscureText, this._validator);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        controller: _controller,
          maxLength: _maxLength,
          textCapitalization: _textCapitalization,
          keyboardType: _keyboardType,
          obscureText: _obscureText,
          validator: _validator,
          decoration: MyInputDecoration(context, _label)
      ),
    );
  }
}
