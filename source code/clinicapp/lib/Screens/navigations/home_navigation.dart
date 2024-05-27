import 'package:clinicapp/Screens/Home/home.dart';
import 'package:clinicapp/Screens/views/wistlist/details_wistlist.dart';
import 'package:clinicapp/Screens/views/wistlist/wistlist.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/detailsHome") {
                return const DetailsWishlistView();
              }
              return const HomePage();
            });
      },
    );
  }
}
