import 'package:flutter/material.dart';

class MyIconData extends IconData {
  const MyIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'MaterialIcons', // Replace with your custom font family
        );
}
