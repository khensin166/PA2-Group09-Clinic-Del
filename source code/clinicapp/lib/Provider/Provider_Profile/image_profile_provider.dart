import 'dart:convert';
import 'dart:typed_data';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/get_profile_provider.dart';
import 'package:clinicapp/Screens/Profile/profile.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileImageProvider extends ChangeNotifier {
  final url = AppUrl.baseUrl;

  bool _status = false;
  String _response = '';
  UserModel? _profile;

  bool get getStatus => _status;
  String get getResponse => _response;
  UserModel? get profile => _profile;

  final GetUserProfile _getUserProfile = GetUserProfile();

  Future<UserModel?> uploadImage(
      Uint8List bytes, String fileName, BuildContext? context) async {
    // Ambil token dan UserId dari Database Provider
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();

    // End point untuk update profile
    final _url = Uri.parse('$url/user-photo/$userId');

    var request = http.MultipartRequest("PUT", _url);
    request.headers['Authorization'] = '$token';
    var myFile = http.MultipartFile(
      'profilePicture',
      http.ByteStream.fromBytes(bytes),
      bytes.length,
      filename: fileName,
    );
    request.files.add(myFile);

    try {
      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = await response.stream.bytesToString();
        _status = false;
        _response = json.decode(data)['message'];
        _profile = UserModel.fromJson(json.decode(data));
        notifyListeners();
        await fetchProfilePhoto();
        PageNavigator(ctx: context).nextPage(page: ProfilePage());
        return _profile;
      } else {
        var errorData = await response.stream.bytesToString();
        print('Failed to upload image: ${response.statusCode} - $errorData');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  Future<void> fetchProfilePhoto() async {
    try {
      _profile = await _getUserProfile.getProfile();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch profile photo');
    }
  }
}
