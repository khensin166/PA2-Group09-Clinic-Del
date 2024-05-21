import 'package:clinicapp/Provider/AppointmentProvider/add_appointment_provider.dart';
import 'package:clinicapp/Provider/AppointmentProvider/delete_appointment_provider.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token = await DatabaseProvider().getToken();
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({Key? key, @required this.token});

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
        // home: (JwtDecoder.isExpired(token) == false) ? HomePage() : LoginPage(),
        // home: Onboarding(),
        home: SplashScreen(),
      ),
    );
  }
}
