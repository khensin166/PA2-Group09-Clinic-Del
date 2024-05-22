import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          title: 'Riwayat Penyakit', backgroundColor: primaryColor),
      body: Center(
        child: Text('Riwayat'),
      ),
    );
  }
}
