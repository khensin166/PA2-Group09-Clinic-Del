import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/home.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAppointmentProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  ///To get graphql client

  ///Add task method
  void addAppointment({String? complaint, BuildContext? context,}) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    final _url = "$url/appointment";

    final body = {
      "complaint": complaint,
      "date": "2022-08-18T11:01:00.000+00:00",
      "time": "2022-09-18T12:00:00.000+00:00",
      "requested_id": userId,
    };

    final result = await http.post(Uri.parse(_url),
        body: body, headers: {'Authorization': '$token'});

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      print(res);
      _status = false;
      _response = json.decode(res)['message'];
      notifyListeners();

      PageNavigator(ctx: context).nextPageOnly(page: const HomePage());
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
