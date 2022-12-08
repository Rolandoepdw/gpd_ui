import 'package:flutter/material.dart';
import 'package:gpd/core/widgets/my_text_area_form_field_decoration.dart';

class MyTextAreaFormField extends StatelessWidget {
  TextEditingController _controller;
  String _label;
  int _minLines;
  int _maxLines;
  TextCapitalization _textCapitalization;
  bool _obscureText;
  String? Function(String?) _validator;

  MyTextAreaFormField.name(
      this._controller,
      this._label,
      this._minLines,
      this._maxLines,
      this._textCapitalization,
      this._obscureText,
      this._validator);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: SingleChildScrollView(
        child: TextFormField(
            controller: _controller,
            maxLength: 300,
            textCapitalization: _textCapitalization,
            keyboardType: TextInputType.multiline,
            minLines: _minLines,
            maxLines: _maxLines,
            obscureText: _obscureText,
            validator: _validator,
            decoration: MyTextAreaFormFieldDecoration(context, _label)),
      ),
    );
  }
}
