import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:http/http.dart' as http;

class GetUserProfile {
  final url = AppUrl.userProfileUrl;

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
        return UserModel();  // Mengembalikan model kosong jika terjadi kesalahan
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  
}
