import 'package:clinicapp/Provider/Provider_Appointment/add_appointment_provider.dart';
import 'package:clinicapp/Provider/Provider_Appointment/delete_appointment_provider.dart';
import 'package:clinicapp/Provider/Provider_Appointment/edit_appointment_provider.dart';
import 'package:clinicapp/Provider/Provider_Auth/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/image_profile_provider.dart';
import 'package:clinicapp/Provider/Provider_Reminder/add_reminder.dart';
import 'package:clinicapp/Provider/Provider_Reminder/delete_reminder.dart';
import 'package:clinicapp/Provider/Provider_Reminder/edit_reminder.dart';
import 'package:clinicapp/Provider/Provider_Reminder/local_notification_service.dart';
import 'package:clinicapp/Provider/view_models.dart/photo_profile_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/update_profile_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // pemanggilan fungsi notifikasi
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  // WidgetsFlutterBinding.ensureInitialized();
  // String token = await DatabaseProvider().getToken();
  runApp(MyApp(
      // token: token,
      ));
}

class MyApp extends StatelessWidget {
  // final token;
  const MyApp({
    Key? key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => AddAppointmentProvider()),
        ChangeNotifierProvider(create: (_) => DeleteAppointmentProvider()),
        ChangeNotifierProvider(create: (_) => EditAppointmentProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => AddReminderProvider()),
        ChangeNotifierProvider(create: (_) => EditReminderProvider()),
        ChangeNotifierProvider(create: (_) => DeleteReminderProvider()),
      ],
      child: MaterialApp(
        title: 'Clinic App',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: true),
        // home: (JwtDecoder.isExpired(token) == false) ? HomePage() : LoginPage(),
        // home: ProfileView(),
        home: SplashScreen(),
      ),
    );
  }
}
