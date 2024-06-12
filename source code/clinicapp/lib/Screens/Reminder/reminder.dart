import 'package:clinicapp/Screens/Home/home.dart';
import 'package:clinicapp/Screens/Reminder/reminder_create.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Styles/theme.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Pengingat Obat',
        backgroundColor: primaryColor,
        nextPage: const HomePage(),
        leadingIcon: Icons.arrow_back,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Today",
                      style: headingStyle,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 80,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryColor,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.medication,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak ada pengingat obat!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity, // Make the button full-width
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const CreateReminderPage());
                        },
                        child: const Text('Tambahkan Pengingat Obat'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
