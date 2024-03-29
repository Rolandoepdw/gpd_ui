import 'package:flutter/material.dart';
import 'package:gpd/core/widgets/my_input_decoration.dart';

class MyTextFormField extends StatelessWidget {
  TextEditingController _controller;
  String _label;
  TextCapitalization _textCapitalization;
  TextInputType _keyboardType;
  bool _obscureText;
  String? Function(String?) _validator;

  MyTextFormField.name(
    this._controller,
    this._label,
    this._textCapitalization,
    this._keyboardType,
    this._obscureText,
    this._validator,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextFormField(
          controller: _controller,
          maxLength: 30,
          textCapitalization: _textCapitalization,
          keyboardType: _keyboardType,
          obscureText: _obscureText,
          validator: _validator,
          decoration: MyInputDecoration(context, _label)),
    );
  }
}
