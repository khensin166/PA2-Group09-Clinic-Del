import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  const Category(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ClipOval(
            child: Container(
              color: primaryColor,
              width: 60,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: black,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
