import 'package:flutter/material.dart';

import 'Fonts.dart';
import 'TextStyle.dart';

class TextFieldStyle {
  primaryTextField(String text, Icon icon, Color color) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: text,
      hintStyle: Text_Style.textStyleNormal(Colors.black38, 15),
      prefixIcon: icon,
      prefixIconColor: color,
      labelStyle: TextStyle(
        fontFamily: Fonts.PrimaryFont,
        fontSize: 16,
        color: Colors.black54,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.5, color: color.withOpacity(0.6)),
      ),
    );
  }

  DescriptionTexrField(String text, Color color) {
    return InputDecoration(
      hintText: text,
      hintStyle: Text_Style.textStyleBold(color, 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6)),
      ),
    );
  }

  DataTextFieldStyle(String text, Icon icon, Color color) {
    return InputDecoration(
      hintText: text,
      prefixIcon: icon,
      prefixIconColor: color,
      labelStyle: TextStyle(
        fontFamily: Fonts.PrimaryFont,
        fontSize: 16,
        color: Colors.black54,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }
}
