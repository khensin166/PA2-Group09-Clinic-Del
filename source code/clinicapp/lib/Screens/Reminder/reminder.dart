import 'package:clinicapp/Screens/Reminder/reminder_create.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Obat'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Kemarin'),
            Tab(text: 'Hari ini'),
            Tab(text: 'Besok'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ReminderContent(day: 'kemarin'),
          ReminderContent(day: 'hari ini'),
          ReminderContent(day: 'besok'),
        ],
      ),
    );
  }
}

class ReminderContent extends StatelessWidget {
  final String day;

  const ReminderContent({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.yMMMMd().format(DateTime.now())),
            const Icon(
              Icons.medication,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Tidak ada pengingat obat $day!',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                PageNavigator(ctx: context)
                    .nextPage(page: const CreateReminderPage());
                // Add your onPressed code here!
              },
              child: const Text('Tambahkan Pengingat Obat'),
            ),
          ],
        ),
      ),
    );
  }
}
