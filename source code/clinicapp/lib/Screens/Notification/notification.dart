import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Izin Sakit',
      'description':
          'Kenan Tomfie Bukit tidak bisa mengikuti pembelajaran karena mengalami sakit perut dan dapat beristirahat selama 1 hari',
      'date': '10-06-2024',
      'time': '07:10 am'
    },
    {
      'title': 'Izin Sakit',
      'description':
          'Wahyu tidak bisa mengikuti pembelajaran karena mengalami sakit perut dan dapat beristirahat selama 1 hari',
      'date': '09-06-2024',
      'time': '12:10 am'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationItem(
            title: notification['title']!,
            description: notification['description']!,
            date: notification['date']!,
            time: notification['time']!,
          );
        },
      ),
    );
  }
}
