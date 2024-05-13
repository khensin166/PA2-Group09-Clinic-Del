import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'appoinment/appoinment.dart'; // Pastikan untuk mengimpor halaman appointment jika belum
import 'clinic_information.dart';
import 'profile/profile.dart';
import 'reminder.dart'; // Pastikan untuk mengimpor halaman pengingat jika belum
import '../widgets/category.dart';
import '../widgets/article.dart';
import '../utils/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AppoinmentPage()));
    } else
    // Jika index adalah 2 (Profil), navigasikan ke halaman profil
    if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.battery_charging_full_outlined),
              label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
        ],
      ),
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
                            InkWell(
                              onTap: () {
                                // Navigasi ke halaman profil saat gambar profil diklik
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ProfilePage()));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
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
                                  Text(
                                    "Halo Aji, Selamat Datang !",
                                  ),
                                ],
                              ),
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
                          child: TextField(
                            cursorHeight: 20,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: "Cari Obat dan Article...",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Category(
                        imagePath: "assets/appoinment.png",
                        title: "Janji Temu",
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const AppoinmentPage());
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
              Article(
                imagePath: 'assets/logo.png',
                nameShop: "Toko Kenanganku",
                rating: "4.9",
                jamBuka: "13.00 - 23.00",
              ),
              Article(
                imagePath: 'assets/logo.png',
                nameShop: "Ketiga Kopi",
                rating: "4.7",
                jamBuka: "13.00 - 20.00",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
