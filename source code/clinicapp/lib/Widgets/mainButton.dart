import 'dart:ui';

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.size,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.hintText,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderSide,
  });

  final Size size;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final String hintText;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderSide;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: 2,
            side: BorderSide(width: 1, color: borderSide),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          height: size.height / height,
          width: size.width / width,
          child: Center(
            child: Text(hintText),
          ),
        ));
  }
}
