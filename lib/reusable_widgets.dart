import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextFormField textFormField(String text, IconData icon, bool obscuredText,
    {required Function onChanged,
      required TextInputType keyboard,
      required TextEditingController controller,
      required String? Function(String?) validator,
      IconButton? suffixIcon}) {
  return TextFormField(
    onChanged: onChanged(),
    obscureText: obscuredText,
    keyboardType: keyboard,
    decoration: InputDecoration(
        errorStyle:const TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1C4374)),
            borderRadius: BorderRadius.circular(15)),
        labelText: text,
        suffixIcon: suffixIcon,
        prefixIcon: Icon(icon)),
    validator: validator,
    controller: controller,

  );
}