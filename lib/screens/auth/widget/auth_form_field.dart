import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  //final String Function(String)? validator;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;
  AuthFormField(
      {required this.hintText,
      required this.icon,
      this.obscureText = false,
      this.validator,
      this.onSaved});
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(90.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ));
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(.1),
          border: border,
          prefixIcon: Icon(icon),
          hintText: hintText),
    );
  }
}
