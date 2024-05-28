import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
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
    BuildContext? context,
  }) async {
    final token = await DatabaseProvider().getToken();
    final user_id = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    final body = {
      "first_time": first_time,
      "second_time": second_time,
      "third_time": third_time,
      "start_date": DateFormat('yyyy-MM-dd').format(start_date),
      "duration": duration,
      "user_id": user_id,
      "name": name,
    };

    final headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    final result = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = json.decode(result.body);
      print(res);
      _status = false;
      _response = res['message'];
      notifyListeners();
      if (context != null) {
        Navigator.pop(context);
      }
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
