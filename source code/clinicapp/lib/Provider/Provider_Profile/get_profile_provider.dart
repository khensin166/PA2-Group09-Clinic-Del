import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/photo_profile_model.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GetUserProfile {
  final url = AppUrl.userProfileUrl;
  // late UserModel userModel;
  Future<UserModel> getProfile() async {
    final token = await DatabaseProvider().getToken();

    try {
      final request = await http.get(
        Uri.parse(url),
        headers: {'Authorization': '$token'},
      );

      print(request.statusCode);

      if (request.statusCode == 200 || request.statusCode == 201) {
        print(request.body);

        if (json.decode(request.body)['data'] == null) {
          return UserModel();
        } else {
          final userModel = userModelFromJson(request.body);
          return userModel;
        }
      } else {
        print(request.body);
        return UserModel(); // Mengembalikan model kosong jika terjadi kesalahan
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  // // late PhotoProfileModel photoProfileModel;
  //  Future<PhotoProfileModel> uploadProfilePhoto({
  //   required XFile photoProfile,
  // }) async {
  //   final token = await DatabaseProvider().getToken();
  //   final userId = await DatabaseProvider().getUserId();

  //   try {
  //     final request = http.MultipartRequest('PUT', Uri.parse('$url/user-photo/$userId'));

  //     request.headers['Authorization'] = '$token';
  //     request.files.add(
  //         await http.MultipartFile.fromPath('photoProfile', photoProfile.path));

  //     final requestResponse = await request.send();

  //     if (requestResponse.statusCode == 200 || requestResponse.statusCode == 201) {
  //       final responseStream = await requestResponse.stream.bytesToString();
  //       final jsonResponse = jsonDecode(responseStream) as Map<String, dynamic>;
  //       return PhotoProfileModel.fromJson(jsonResponse);
  //     } else {
  //       return Future.error('Failed to upload profile photo');
  //     }
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }
}

