import 'package:clinicapp/Screens/History/history.dart';
import 'package:clinicapp/Screens/views/updates/details_updates.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

GlobalKey<NavigatorState> historyNavigatorKey = GlobalKey<NavigatorState>();

class HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: historyNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == "/detailsUpdates") {
              return const DetailsUpdatesView();
            }
            return const HistoryPage();
          },
        );
      },
    );
  }
}
