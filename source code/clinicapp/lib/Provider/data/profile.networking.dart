import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/photo_profile_model.dart';
import 'package:clinicapp/Model/view_profile_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileNetworking {
  final client = http.Client();
  final url = AppUrl.baseUrl;

  Future<ProfileDataModel> getProfileData() async {
    final token = await DatabaseProvider().getToken();
    late ProfileDataModel profileDataModel;

    try {
      final request = await client.post(Uri.parse('$url/user-photo'), body: {
        "token": token,
      });

      if (request.statusCode == 200) {
        final response = json.decode(request.body);
        profileDataModel = ProfileDataModel.fromJson(response);
      } else {
        return Future.error('Failed to load profile data');
      }
    } catch (e) {
      return Future.error(e);
    }

    return profileDataModel;
  }

  Future<UploadProfilePicModel> uploadProfilePhoto({
    required XFile photoProfile,
  }) async {
    final token = await DatabaseProvider().getToken();
    final userId = await DatabaseProvider().getUserId();

    try {
      final request =
          http.MultipartRequest('PUT', Uri.parse('$url/user-photo/$userId'));
      request.headers['Authorization'] = '$token';
      request.files.add(
          await http.MultipartFile.fromPath('photoProfile', photoProfile.path));

      final requestResponse = await request.send();

      if (requestResponse.statusCode == 200) {
        final responseString = await requestResponse.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString) as Map<String, dynamic>;
        return UploadProfilePicModel.fromJson(jsonResponse);
      } else {
        return Future.error('Failed to upload profile photo');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
