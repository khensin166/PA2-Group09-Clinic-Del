import 'package:clinicapp/Screens/Authentication/login.dart';
import 'package:clinicapp/Screens/Home/main_wrapper.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'Provider/Database/db_provider.dart';

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
    Future.delayed(const Duration(seconds: 2), () {
      // call value token yang disimpan di dalam DatabaseProvider
      DatabaseProvider().getToken().then((value) {
        if (value == null || value.isEmpty) {
          // Handle case where the token is null or empty
          PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
          return;
        }

        try {
          if (JwtDecoder.isExpired(value) == true) {
            PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
          } else {
            PageNavigator(ctx: context).nextPageOnly(page: const MainWrapper());
          }
        } catch (e) {
          // Handle invalid token format
          print('Error decoding token: $e');
          PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
        }
      }).catchError((error) {
        // Handle errors from the database
        print('Error fetching token: $error');
        PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
      });
    });
  }
}
