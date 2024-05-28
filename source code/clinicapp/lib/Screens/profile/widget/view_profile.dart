import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewProfile extends StatelessWidget {
  final String photoProfile;
  const ViewProfile({super.key, required this.photoProfile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: PhotoView(imageProvider: NetworkImage(photoProfile)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
