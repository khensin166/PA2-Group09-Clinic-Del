import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  final String imagePath;
  final String title;
  final String publishedAt;
  const Article(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.publishedAt})
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
                          title,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                color: Colors.grey),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              publishedAt,
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
