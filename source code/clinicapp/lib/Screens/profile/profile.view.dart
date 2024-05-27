import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Provider/view_models.dart/photo_profile_provider.dart';
import 'package:clinicapp/Screens/Profile/widget/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();
    XFile? imageFile;
    final userProfile = Provider.of<UserProfileProvider>(context, listen: true);

    void selectImage() async {
      try {
        final XFile? selectedImage =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (selectedImage != null && selectedImage.path.isNotEmpty) {
          imageFile = selectedImage;
          await userProfile.uploadProfile(photoProfile: imageFile!);
          if (userProfile.uploadProfilePicModel.status == "200") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                content: Text("Profile image updated")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text("Failed to update profile image")));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text("Ada kesalahan: $e")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: userProfile.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: const Text('Select'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        selectImage();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Update image'),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ViewProfile(
                                                photoProfile: userProfile
                                                        .profileDataModel
                                                        .data
                                                        .profilePicture
                                                        .isNotEmpty
                                                    ? userProfile
                                                        .profileDataModel
                                                        .data
                                                        .profilePicture
                                                    : "https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg")));
                                      },
                                      child: const Text('View image'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 75,
                          child: CircleAvatar(
                            radius: 70,
                            foregroundImage: NetworkImage(
                                '${AppUrl.userProfilePhotoUrl}/${userProfile.uploadProfilePicModel.image}'),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(50, 50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.amber),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
