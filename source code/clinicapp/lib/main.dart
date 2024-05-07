import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/register.dart';
import 'package:clinicapp/onBoarding.dart';
import 'package:clinicapp/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // Atur tema aplikasi di sini
            ),
        home: const SplashScreen(),
      ), // Kurung kurawal ini harus berada di sini
    );
  }
}
