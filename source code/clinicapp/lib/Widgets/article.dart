import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  final String imagePath;
  final String nameShop;
  final String rating;
  final String jamBuka;
  const Article(
      {Key? key,
      required this.imagePath,
      required this.nameShop,
      required this.rating,
      required this.jamBuka})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 240,
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Image.asset(imagePath, fit: BoxFit.cover))
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 10,
                child: SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameShop,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            // Icon(Icons.star, color: Colors.amber),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            // Text(
                            //   rating,
                            // ),
                            // SizedBox(
                            //   width: 20,
                            // ),
                            Icon(Icons.calendar_today_outlined,
                                color: Colors.grey),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              jamBuka,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
