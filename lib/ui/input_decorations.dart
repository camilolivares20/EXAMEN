import 'package:flutter/material.dart';

class InputDecortions {
  static InputDecoration authInputDecoration({
    required String hinText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 16, 70, 195),
        )),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 16, 70, 195),
          width: 3,
        )),
        hintText: hinText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 6, 0, 0)),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color.fromARGB(255, 0, 30, 255),
              )
            : null);
  }
}