import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Appointment/appointment.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditAppointmentProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;
  String _response = '';

  bool get getStatus => _status;
  String get getResponse => _response;

  void editAppointment({
    String? complaint,
    BuildContext? context,
    DateTime? date,
    TimeOfDay? time,
    required String oldAppointmentId,
  }) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    final appointmentDateTime = DateTime(
      date!.year,
      date.month,
      date.day,
      time!.hour,
      time.minute,
    );

    // Konversi ke format ISO 8601 dengan zona waktu
    final dateIsoString = appointmentDateTime.toIso8601String();
    print(dateIsoString);

    final body = {
      "complaint": complaint,
      "date": dateIsoString,
      "time": dateIsoString,
      "requested_id": userId,
    };

    final result = await http.put(
      Uri.parse('$url/update-appointment/$oldAppointmentId'),
      body: body,
      headers: {'Authorization': '$token'},
    );

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      _status = false;
      _response = json.decode(res)['message'];
      notifyListeners();

      PageNavigator(ctx: context).nextPageOnly(page: const AppointmentPage());
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
