import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Appointment/appointment.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteAppointmentProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  ///To get graphql client

  ///Add task method
  void deleteAppointment({String? appointmentId, BuildContext? ctx}) async {
    final token = await DatabaseProvider().getToken();
    _status = true;
    notifyListeners();

    final _url = "$url/appointment/$appointmentId";

    final result = await http
        .delete(Uri.parse(_url), headers: {'Authorization': "$token"});

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      print(res);
      _status = false;

      _response = json.decode(res)['message'];

      notifyListeners();
      PageNavigator(ctx: ctx).nextPageOnly(page: const AppointmentPage());
    } else {
      final res = result.body;
      print(res);
      _status = false;

      _response = json.decode(res)['message'];

      notifyListeners();
    }
  }

  void clear() {
    _response = '';
    notifyListeners();
  }
}
