import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Reminder/reminder.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddReminderProvider extends ChangeNotifier {
  final String url = AppUrl.ReminderUrl; // Ganti dengan URL API Anda

  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  void addReminder({
    required String name,
    required String first_time,
    required String second_time,
    required String third_time,
    required DateTime start_date,
    required int duration,
    required BuildContext context,
  }) async {
    final token = await DatabaseProvider().getToken();
    final user_id_string = await DatabaseProvider().getUserId();
    final user_id = int.parse(user_id_string);
    final start_datee = DateFormat('yyyy-MM-dd').format(start_date).toString();
    _status = true;
    notifyListeners();

    final body = jsonEncode({
      "first_time": first_time,
      "second_time": second_time,
      "third_time": third_time,
      "start_date": start_datee,
      "duration": duration,
      "user_id": user_id, // Pastikan user_id dikirim sebagai integer
      "name": name,
    });

    final result = await http.post(
      Uri.parse(url),
      headers: {'Authorization': '$token', 'Content-Type': 'application/json'},
      body: body,
    );

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = json.decode(result.body);
      print(res);
      _status = false;
      _response = res['message'];
      notifyListeners();
      PageNavigator(ctx: context!).nextPageOnly(page: ReminderPage());
    } else {
      final res = json.decode(result.body);
      print(res);

      _response = res['message'];

      _status = false;

      notifyListeners();
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
