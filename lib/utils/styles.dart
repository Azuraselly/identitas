import 'package:flutter/material.dart';

class Styles {
  static const header = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const sub = TextStyle(fontSize: 14, color: Colors.black54);
  static const btnText = TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
  static const avatarText = TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
  static const cardTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const cardSub = TextStyle(fontSize: 13, color: Colors.black54);

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B5E20))),
    );
  }
}
