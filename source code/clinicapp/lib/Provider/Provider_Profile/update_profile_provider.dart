import 'dart:convert';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Profile/detail_profile.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProfileProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;

  String _response = '';

  bool get getStatus => _status;

  String get getResponse => _response;

  ///Update Profile method
  void UpdateProfile({
    String? name,
    String? birthday,
    String? nik,
    String? phone,
    String? gender,
    String? weight,
    String? height,
    String? address,
    BuildContext? context,
  }) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();
    _status = true;
    notifyListeners();

    final body = {
      'name': name,
      'birthday': birthday,
      'nik': nik,
      'phone': phone,
      'gender': gender,
      'weight': weight,
      'height': height,
      'address': address,
    };

    final _url = "$url/user/$userId";
    final result = await http
        .put(Uri.parse(_url), body: body, headers: {'Authorization': '$token'});

    print(result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      final res = result.body;
      print(res);
      _status = false;
      _response = json.decode(res)['message'];
      notifyListeners();

      PageNavigator(ctx: context).nextPageOnly(page: const DetailProfilePage());
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
