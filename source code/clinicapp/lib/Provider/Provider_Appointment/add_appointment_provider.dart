import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Appointment/appointment.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAppointmentProvider extends ChangeNotifier {
  final url = AppUrl.AppointmentUrl;

  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  ///To get graphql client

  ///Add task method
  void addAppointment(
      {String? complaint,
      BuildContext? context,
      DateTime? date,
      TimeOfDay? time}) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

// Gabungkan tanggal dan waktu ke dalam satu DateTime
    final appointmentDateTime = DateTime(
      date!.year,
      date.month,
      date.day,
      time!.hour,
      time.minute,
    );

// Konversi ke format ISO 8601 dengan zona waktu
    final dateIsoString = appointmentDateTime.toIso8601String();

    final body = {
      "complaint": complaint,
      "date": dateIsoString,
      "time": dateIsoString,
      "requested_id": userId,
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
      PageNavigator(ctx: context).nextPageOnly(page: const AppointmentPage());
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
