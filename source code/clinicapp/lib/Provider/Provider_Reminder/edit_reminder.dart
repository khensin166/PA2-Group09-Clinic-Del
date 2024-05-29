import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Appointment/appointment.dart';
import 'package:clinicapp/Screens/Reminder/reminder.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditReminderProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  void editReminder({
    required int id,
    String? name,
    String? first_time,
    String? second_time,
    String? third_time,
    DateTime? start_date,
    int? duration,
    BuildContext? context,
  }) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    final body = {
      "name": name,
      "first_time": first_time,
      "second_time": second_time,
      "third_time": third_time,
      "start_date": DateFormat('yyyy-MM-dd').format(start_date!).toString(),
      "duration": duration,
      "requested_id": userId,
    };

    final result = await http.put(
      Uri.parse('$url/reminder/$id'),
      body: json.encode(body),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
    );

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      _status = false;
      _response = json.decode(res)['message'];
      notifyListeners();

      PageNavigator(ctx: context).nextPageOnly(page: const ReminderPage());
    } else {
      final res = result.body;
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
