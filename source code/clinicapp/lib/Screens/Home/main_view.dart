// import 'package:clinicapp/Screens/History/history.dart';
// import 'package:clinicapp/Screens/Home/home.dart';
// import 'package:clinicapp/Screens/Profile/profile.dart';
// // import 'package:clinicapp/Screens/navigations/profile_navigation.dart';
// import 'package:clinicapp/Styles/colors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class MainView extends StatefulWidget {
//   const MainView({Key? key}) : super(key: key);

//   @override
//   State<MainView> createState() => _MainViewState();
// }

// class _MainViewState extends State<MainView> {
//   final _pages = [const HomePage(), const HistoryPage(), const ProfilePage()];
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         child: IndexedStack(
//           index: _currentIndex,
//           children: _pages,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: const ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           shadows: [
//             BoxShadow(
//               color: Color(0x0F000000),
//               blurRadius: 40,
//               offset: Offset(0, 0),
//               spreadRadius: 0,
//             )
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (value) => setState(() {
//             _currentIndex = value;
//           }),
//           type: BottomNavigationBarType.fixed,
//           showUnselectedLabels: false,
//           iconSize: 24,
//           selectedItemColor: primaryColor,
//           unselectedItemColor: primaryColor,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               activeIcon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.assignment_outlined),
//               activeIcon: Icon(Icons.assignment),
//               label: 'Riwayat Penyakit',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.account_circle_outlined),
//               activeIcon: Icon(Icons.account_circle),
//               label: 'Profile',
//             ),
//           ],
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }
