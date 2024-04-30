import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/onBoarding.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Image.asset('assets/logo.png'),
        )
      ]),
    );
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
    });
  }
}
