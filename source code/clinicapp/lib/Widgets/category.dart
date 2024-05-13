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
    return InkWell(
      onTap: onTap,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 50,
            height: 60,
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
