import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static onTap(NotificationResponse notificationResponse) {}
  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: onTap,
        onDidReceiveNotificationResponse: onTap);
  }

  // basic notification
  static void showBasicNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 1', 'basic notification',
        importance: Importance.max, priority: Priority.high);
    NotificationDetails details = const NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
        0, 'Basic Notification', 'body', details,
        payload: "Payload Data");
  }

  // show Repeated notification
  static void showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 2', 'Repeated notification',
        importance: Importance.max, priority: Priority.high);
    NotificationDetails details = const NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.periodicallyShow(
        1, 'Repeated Notification', 'body', RepeatInterval.everyMinute, details,
        payload: "Payload Data");
  }

  // show Scheduled notification
  static void showScheduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 3', 'Scheduled notification',
        importance: Importance.max, priority: Priority.high);
    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     3, 'ScheduledNotification', 'body', tz, details,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
