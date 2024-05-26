import 'package:clinicapp/Model/photo_profile_model.dart';
import 'package:clinicapp/Model/view_profile_model.dart';
import 'package:clinicapp/Provider/data/profile.networking.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileProvider extends ChangeNotifier {
  final ProfileNetworking _profileNetworking = ProfileNetworking();
  late ProfileDataModel profileDataModel;

  Future getProfile() async {
    try {
      profileDataModel = await _profileNetworking.getProfileData();
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  late UploadProfilePicModel uploadProfilePicModel;

  Future uploadProfile({required XFile photoProfile}) async {
    try {
      uploadProfilePicModel = await _profileNetworking.uploadProfilePhoto(
          photoProfile: photoProfile);

      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }
}
