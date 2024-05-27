import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const AddButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: primaryColor),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: white),
          ),
        ),
      ),
    );
  }
}
