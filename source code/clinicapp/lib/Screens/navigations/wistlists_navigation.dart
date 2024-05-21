import 'package:clinicapp/Screens/Home/home.dart';
import 'package:clinicapp/Screens/views/wistlist/details_wistlist.dart';
import 'package:clinicapp/Screens/views/wistlist/wistlist.dart';
import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  WishlistState createState() => WishlistState();
}

GlobalKey<NavigatorState> wishListNavigatorKey = GlobalKey<NavigatorState>();

class WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: wishListNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/detailsWishlist") {
                return const DetailsWishlistView();
              }
              return const HomePage();
            });
      },
    );
  }
}
