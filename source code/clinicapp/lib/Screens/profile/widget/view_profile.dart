import 'package:clinicapp/Constants/url.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewProfile extends StatelessWidget {
  final String photoProfile;
  const ViewProfile({super.key, required this.photoProfile});

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: NetworkImage(photoProfile));
  }
}
