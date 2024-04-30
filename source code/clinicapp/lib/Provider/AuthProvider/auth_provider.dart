import 'dart:convert';
import 'dart:io';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/login.dart';
import 'package:clinicapp/Screens/register.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  // Pemanggilan base url
  final requestBaseUrl = AppUrl.baseUrl;

  // Setter
  bool _isLoading = false;
  String _resMessage = "";

  // Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  // function method untuk registerasi user
  void registerUser({
    required String username,
    required String password,
    BuildContext? context}) async {
    _isLoading = true;
    notifyListeners();

    // pemanggilan api
    String url = "$requestBaseUrl/user";

    // Data yang dikirim
    final body = {
      'username': username,
      'password': password,
    };

    print(body);
    try {
      // buat data with post method untuk mengirim data ke api
      http.Response req = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: body);

      // Cetak respons untuk debugging
      print('Response body: ${req.body}');

      // Pengkondisian jika berhasil atau error
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        final message = res['message'];
        final userData = res['data'];
        final user = User.fromJson(userData); // Mengurai respons ke objek User
        print(message);
        print(user.username); // Mengakses data pengguna menggunakan objek User
        _isLoading = false;
        _resMessage = "Account Created!";
        notifyListeners();
        PageNavigator(ctx: context).nextPageOnly(page: LoginPage());
      } else {
        // final res = json.decode(req.body);
        // final message = res['message'];
        _resMessage = "Registration failed!";
        print(_resMessage);
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      _isLoading = false;
      _resMessage = "Internet connection is not available` and ${e.message}";
      print(_resMessage);
      notifyListeners();
    } on http.ClientException catch (e) {
      _isLoading = false;
      _resMessage = "HTTP error ${e.message}";
      print(_resMessage);
      notifyListeners();
    } on FormatException catch (e) {
      _isLoading = false;
      _resMessage = "Server response format is invalid. Please try again.";
      notifyListeners();
      print("Error: Unexpected response format: $e");
    } catch (e) {
      _isLoading = false;
      _resMessage = "Registrasi gagal. Silahkan coba lagi.";
      notifyListeners();
      print(":::: $e");
    }
  }

//Login
  void loginUser({
    required String username,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/login";

    final body = {"username": username, "password": password};
    print(body);

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );

      // Check if response body is not empty before decoding JSON
      if (req.body.isNotEmpty) {
        final res = json.decode(req.body);

        print(res);
        _isLoading = false;
        _resMessage = "Login successfull!";
        notifyListeners();

        ///Save users data and then navigate to homepage
        // final userId = res['user']['id'];
        final token = res['authToken'];
        DatabaseProvider().saveToken(token);
        // DatabaseProvider().saveUserId(userId);
        PageNavigator(ctx: context).nextPageOnly(page: const RegisterPage());
      } else {
        _resMessage = "Empty response body";
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again";
      notifyListeners();

      print(":::: $e");
    }
  }

  void clear() {
    _resMessage = "";
    // _isLoading is false
    notifyListeners();
  }
}

class User {
  final int id;
  final String name;
  final int age;
  final int weight;
  final int height;
  final int nik;
  final String birthday;
  final String gender;
  final String address;
  final String phone;
  final String username;
  final String password;
  // final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.nik,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.phone,
    required this.username,
    required this.password,
    // required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      nik: json['nik'],
      birthday: json['birthday'],
      gender: json['gender'],
      address: json['address'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      // role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
