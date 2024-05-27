import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Reminder/reminder.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddReminderProvider extends ChangeNotifier {
  final url = AppUrl.ReminderUrl;

  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  //To get graphql client

  //Add task method
  void addReminder(
      {String? name,
      BuildContext? context,
      TimeOfDay? time,
      int? frequency,
      int? duration}) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    DateTime date = DateTime.now();
    // Gabungkan tanggal dan waktu ke dalam satu DateTime
    final reminderDateTime = DateTime(
      date!.year,
      date.month,
      date.day,
      time!.hour,
      time.minute,
    );

    // Konversi ke format ISO 8601 dengan zona waktu
    final dateIsoString = reminderDateTime.toIso8601String();

    final body = {
      "date_time": dateIsoString,
      "frequency": frequency.toString(),
      "duration": duration.toString(),
      "name": name,
    };

    final result = await http
        .post(Uri.parse(url), body: body, headers: {'Authorization': '$token'});

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      print(res);
      _status = false;
      _response = json.decode(res)['message'];
      notifyListeners();
      // Navigator.pop(context!);
      PageNavigator(ctx: context).nextPage(page: const ReminderPage());
    } else {
      final res = result.body;
      print(res);

      _response = json.decode(res)['message'];

      _status = false;

      notifyListeners();
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
