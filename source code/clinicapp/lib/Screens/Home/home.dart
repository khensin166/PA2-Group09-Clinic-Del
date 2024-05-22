import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Widgets/search_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Appoinment/appointment.dart'; // Pastikan untuk mengimpor halaman appointment jika belum
import '../Clinic_Information/clinic_information.dart';
import '../Profile/profile.dart';
import '../Reminder/reminder.dart'; // Pastikan untuk mengimpor halaman pengingat jika belum
import '../../widgets/category.dart';
import '../../widgets/article.dart';
import '../../utils/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat pagi';
    } else if (hour < 17) {
      return 'Selamat siang';
    } else if (hour < 19) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    color: primaryColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    // Hilangkan gambar profil
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://studiolorier.com/wp-content/uploads/2018/10/Profile-Round-Sander-Lorier.jpg"),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                FutureBuilder<UserModel?>(
                                  future: Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .getUserData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      final name =
                                          snapshot.data?.name ?? 'User';
                                      return GestureDetector(
                                        onTap: () {
                                          // Kosongkan onTap agar tidak dapat diklik
                                        },
                                        child: Text(
                                          '${_getGreeting()}\n$name',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    } else {
                                      return Text('No user data available');
                                    }
                                  },
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: const Icon(
                                Icons.notifications_active,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: searchFields()),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Category(
                        imagePath: "assets/appoinment.png",
                        title: "Janji Temu",
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const AppointmentPage());
                        },
                      ),
                    ),
                    Expanded(
                      child: Category(
                        imagePath: "assets/add_reminder.png",
                        title: "Pengingat Obat",
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const ReminderPage());
                        },
                      ),
                    ),
                    Expanded(
                      child: Category(
                        imagePath: "assets/clinic.png",
                        title: "Informasi Klinik",
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const ClinicInformation());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Article",
                ),
              ),
              Article(
                imagePath: 'assets/logo.png',
                nameShop: "Aku Kopi",
                rating: "4.8",
                jamBuka: "10.00 - 23.00",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
