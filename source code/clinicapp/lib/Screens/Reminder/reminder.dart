import 'package:clinicapp/Model/reminder_model.dart';
import 'package:clinicapp/Provider/Provider_Reminder/get_reminder.dart';
import 'package:clinicapp/Screens/Home/home.dart';
import 'package:clinicapp/Screens/Reminder/reminder_create.dart';
import 'package:clinicapp/Screens/Reminder/reminder_detail.dart';
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
  late Future<ReminderModel> _reminderFuture;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _reminderFuture = GetUserReminder().getReminder(date: formattedDate);
  }

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
                      fontSize: 20, fontWeight: FontWeight.w600)),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  _reminderFuture =
                      GetUserReminder().getReminder(date: formattedDate);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<ReminderModel>(
              future: _reminderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.data == null ||
                    snapshot.data!.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.medication,
                            size: 100, color: Colors.blue),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak ada pengingat obat!',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            PageNavigator(ctx: context)
                                .nextPage(page: const CreateReminderPage());
                          },
                          child: const Text('Tambahkan Pengingat Obat'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      final reminder = snapshot.data!.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            PageNavigator(ctx: context).nextPage(
                                page: DetailRemainderPage(
                              duration: reminder.duration,
                              firstTime: reminder.firstTime!,
                              secondTime: reminder.secondTime ?? '',
                              thirdTime: reminder.thirdTime ?? '',
                              id: reminder.id,
                              startDate: reminder.startDate,
                              name: reminder.name ?? '',
                            ));
                          },
                          child: Card(
                            // Define the shape of the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // Define how the card's content should be clipped
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            // Define the child widget of the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add padding around the row widget
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Add an image widget to display an image
                                      Image.asset(
                                        'assets/reminder.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      // Add some spacing between the image and the text
                                      Container(width: 20),
                                      // Add an expanded widget to take up the remaining horizontal space
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Add some spacing between the top of the card and the title
                                            Container(height: 5),
                                            // Add a title widget
                                            Text(reminder.name!,
                                                style: subHeadingStyle.copyWith(
                                                    color: black)),
                                            // Add some spacing between the title and the subtitle
                                            Container(height: 5),
                                            // Add a subtitle widget
                                            const Text(
                                              'Anda akan menerima pengingat pada:',
                                            ),
                                            // Add some spacing between the subtitle and the text
                                            Container(height: 10),
                                            // Add a text widget to display some text
                                            Text(
                                              '${reminder.firstTime!}, ${reminder.secondTime!}, ${reminder.thirdTime!}',
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          PageNavigator(ctx: context)
              .nextPage(page: const CreateReminderPage());
        },
        tooltip: 'Tambahkan Pengingat Obat',
        icon: const Icon(Icons.add),
        label: const Text('Buat pengingat obat'),
      ),
    );
  }
}
