import 'package:clinicapp/Provider/AppointmentProvider/add_appointment_provider.dart';
import 'package:clinicapp/Provider/AppointmentProvider/delete_appointment_provider.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
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
        ChangeNotifierProvider(create: (_) => AddAppointmentProvider()),
        ChangeNotifierProvider(create: (_) => DeleteAppointmentProvider()),
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
