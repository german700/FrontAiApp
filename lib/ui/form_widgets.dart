import 'package:flutter/material.dart';

Widget createField(String label, String errorMessage, controller,
    [hidden = false, validator]) {
  validator ??= (value) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  };
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
        obscureText: hidden,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: label),
        validator: validator),
  );
}
