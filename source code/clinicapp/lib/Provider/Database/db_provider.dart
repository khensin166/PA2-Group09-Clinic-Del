import 'package:clinicapp/Screens/Authentication/login.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = '';

  String _userId = '';

  String get token => _token;

  String get userId => _userId;


  void saveToken(String token) async {
    SharedPreferences value = await _pref;

    value.setString('token', token);
  }

  void saveUserId(String id) async {
    SharedPreferences value = await _pref;

    value.setString('id', id);
  }

  void saveUserName(String username) async {
    SharedPreferences value = await _pref;

    value.setString('username', username);
  }

  Future<String> getToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('token')) {
      String data = value.getString('token')!;
      _token = data;
      notifyListeners();
      return data;
    } else {
      _token = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getUserId() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('id')) {
      String data = value.getString('id')!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = '';
      notifyListeners();
      return '';
    }
  }


  Future<void> removeToken() async {
    SharedPreferences value = await _pref;
    value.remove('token');
  }

  void logOut(BuildContext context) async {
    final value = await _pref;
    
    value.clear();

    PageNavigator(ctx: context).nextPageOnly(page: const Onboarding());
  }
}
