import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniTextField extends StatelessWidget {
  String hint;
  bool password;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  Color backgroundColor;
  List<TextInputFormatter> inputFormaters;
  Widget suffixIcon;
  Function onTap;
  bool autofocus;
  bool readOnly;
  TextAlign textAlign;

  UniTextField(
    this.hint, {
    this.password = false,
    this.autofocus = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.backgroundColor,
    this.inputFormaters,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      inputFormatters: inputFormaters,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: backgroundColor,
        filled: true,
        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12),
        errorStyle: TextStyle(color: Colors.white),
        suffixIcon: suffixIcon,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
