import 'package:flutter/material.dart';

class TextFomrFieldTheme {
  TextFomrFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      prefixIconColor: Colors.black54,
      floatingLabelStyle: const TextStyle(color: Colors.black54),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.black54),
      ));
}
