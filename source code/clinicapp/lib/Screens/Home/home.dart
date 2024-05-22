import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Screens/Notification/notification.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Widgets/search_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Appoinment/appointment.dart'; // Pastikan untuk mengimpor halaman appointment jika belum
import '../Clinic_Information/clinic_information.dart';
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
                                FutureBuilder<UserModel?>(
                                  future: Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .getUserData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        alignment: Alignment.topLeft,
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      final user = snapshot.data;
                                      final profileImageUrl = user
                                              ?.profilePicture ??
                                          'https://studiolorier.com/wp-content/uploads/2018/10/Profile-Round-Sander-Lorier.jpg';
                                      final name = user?.name ?? 'User';

                                      return Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    profileImageUrl ??
                                                        'https://studiolorier.com/wp-content/uploads/2018/10/Profile-Round-Sander-Lorier.jpg'),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
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
                                          GestureDetector(
                                            onTap: () {
                                              // Kosongkan onTap agar tidak dapat diklik
                                            },
                                            child: Text(
                                              '${AuthenticationProvider().getGreeting()}\n$name',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
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
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  print('test');
                                  PageNavigator(ctx: context)
                                      .nextPage(page: const NotificationPage());
                                },
                                icon: Icon(
                                  Icons.notifications_active,
                                  size: 40,
                                ),
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
                  child: Column(
                    children: [
                      Text(
                        "Health Article",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Article(
                        imagePath: 'assets/health_article.jpg',
                        nameShop: "The 25 Healthiest Fruits You Can Eat",
                        rating: "4.8",
                        jamBuka: "Jun 10, 20223",
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
