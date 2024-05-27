import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageNavigator {
  PageNavigator({this.ctx});
  BuildContext? ctx;

  // Navigator to next page
  Future nextPage({Widget? page}) {
    return Navigator.push(
        ctx!, CupertinoPageRoute(builder: ((context) => page!)));
  }

  void nextPageOnly({Widget? page}) {
    Navigator.pushAndRemoveUntil(
        ctx!, MaterialPageRoute(builder: (context) => page!), (route) => false);
  }

  Future<void> toNextPage({required BuildContext ctx, required Widget page}) {
    return Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
