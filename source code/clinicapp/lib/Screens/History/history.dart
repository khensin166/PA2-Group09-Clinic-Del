import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Styles/theme.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:clinicapp/Widgets/button_add.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
            title: 'Riwayat Penyakit', backgroundColor: primaryColor),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMMd().format(DateTime.now()),
                          style: subHeadingStyle,
                        ),
                        Text(
                          "Today",
                          style: headingStyle,
                        )
                      ],
                    ),
                  ),
                  AddButton(label: "Tambah Pengingat Obat", onTap: () => null)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: primaryColor,
                selectedTextColor: Colors.white,
                dateTextStyle: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                onDateChange: (date) {
                  // simpan date ke dalam variable
                  _selectedDate = date;
                },
              ),
            )
          ],
        ));
  }
}
