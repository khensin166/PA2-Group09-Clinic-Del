import 'package:clinicapp/component/colors.dart';
import 'package:flutter/material.dart';

import 'component/mainButton.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: size.height / 50),
            const Text(
              "Let's get started",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            SizedBox(height: size.height / 80),
            const Text(
              "Login to stay healty and fit",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: size.height / 30),
            MainButton(
              size: size,
              height: 15,
              width: 2.2,
              onPressed: () {},
              hintText: 'Login',
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              borderSide: AppColors.mainColor,
            ),
            SizedBox(height: size.height / 70),
            MainButton(
              size: size,
              height: 15,
              width: 2.2,
              onPressed: () {},
              hintText: "Registrasi",
              backgroundColor: Colors.white,
              foregroundColor: AppColors.mainColor,
              borderSide: AppColors.mainColor,
            )
          ],
        ),
      ),
    );
  }
}
