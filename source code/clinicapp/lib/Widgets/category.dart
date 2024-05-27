import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const Category({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: 60,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                imagePath,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: black,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
