import 'dart:typed_data';

import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Provider/Provider_Auth/auth_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/get_profile_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/image_profile_provider.dart';
import 'package:clinicapp/Screens/Profile/detail_profile.dart';
import 'package:clinicapp/Screens/Profile/profile.view.dart';
import 'package:clinicapp/Screens/Profile/widget/view_profile.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel user = UserModel();

  Future<void> _refreshProfile() async {
    try {
      final profileProvider =
          Provider.of<ProfileImageProvider>(context, listen: false);
      await profileProvider.fetchProfilePhoto();
      setState(() {
        user = profileProvider.profile!;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to refresh profile: $e'),
      ));
    }
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Photo Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (image != null) {
                    Uint8List bytes = await image.readAsBytes();
                    final profileImageProvider =
                        Provider.of<ProfileImageProvider>(context,
                            listen: false);
                    profileImageProvider
                        .uploadImage(bytes, image.name, context)
                        .then((value) async {
                      if (value != null) {
                        await profileImageProvider.fetchProfilePhoto();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Foto profil berhasil diperbarui'),
                        ));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Gagal memperbaharui foto profil'),
                        ));
                        Navigator.pop(context);
                      }
                    }).onError((error, stackTrace) {
                      print(error.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Gagal memperbaharui foto profil: $error'),
                      ));
                    });
                  }
                },
                child: Text('Ganti Photo Profile'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImageProvider = Provider.of<ProfileImageProvider>(context);

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Profile',
        backgroundColor: primaryColor,
        leadingIcon: Icons.manage_accounts,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<UserModel>(
            future: GetUserProfile().getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                user = snapshot.data!;

                // Periksa jika ada pembaruan profil
                if (profileImageProvider.profile != null) {
                  user = profileImageProvider.profile!;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: amber, // Warna border
                                  width: 4.0, // Ketebalan border
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewProfile(
                                            photoProfile: user.profilePicture !=
                                                    null
                                                ? '${AppUrl.userProfilePhotoUrl}/${user.profilePicture}'
                                                : 'https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg',
                                          )));
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    user.profilePicture != null
                                        ? '${AppUrl.userProfilePhotoUrl}/${user.profilePicture}'
                                        : 'https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showSettingsModal(context);
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(6), // Padding sekitar ikon
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .yellow, // Warna latar belakang ikon edit
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: black, // Warna ikon edit
                                    size: 20, // Ukuran ikon edit
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                        child: Column(
                      children: [
                        Text(
                          user.name ?? "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(user.username ?? '')
                      ],
                    )),
                    const SizedBox(height: 30),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.man_sharp, color: Colors.blue),
                        title: Text('Personal Data',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Lihat lengkap data diri anda'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: DetailProfilePage());
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.settings, color: Colors.red),
                        title: Text('Setelan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Akses untuk ubah pengaturan'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: ProfileView());
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SwitchListTile(
                        secondary: Icon(Icons.dark_mode, color: Colors.orange),
                        title: Text('Dark mode',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Automatic'),
                        value: true, // Replace with your dark mode state
                        onChanged: (bool value) {
                          // Handle switch toggle
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Pemanggilan fungsi logout
                          logOut(context);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                    child: Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          DatabaseProvider().logOut(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.logout_outlined),
                            const SizedBox(width: 8),
                            const Text('Logout')
                          ],
                        ),
                      ),
                    ),
                    Text('No user data available')
                  ],
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
