import 'package:clinicapp/Screens/Profile/edit_profile.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/fields_profile.dart';
import 'package:clinicapp/Widgets/fields_text.dart';
import 'package:flutter/material.dart';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Provider_Profile/get_profile_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Widgets/app_bar.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({Key? key}) : super(key: key);

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  late UserModel user = UserModel();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController birthdayController = TextEditingController();
  late TextEditingController nikController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController genderController = TextEditingController();
  late TextEditingController weightController = TextEditingController();
  late TextEditingController heightController = TextEditingController();
  late TextEditingController addressController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    UserModel? userProfile = await GetUserProfile().getProfile();
    if (userProfile != null) {
      setState(() {
        user = userProfile;
        nameController.text = user.name ?? '';
        birthdayController.text = user.birthday ?? '';
        nikController.text = user.nik?.toString() ?? '';
        phoneController.text = user.phone ?? '';
        genderController.text = user.gender ?? '';
        weightController.text = user.weight?.toString() ?? '';
        heightController.text = user.height?.toString() ?? '';
        addressController.text = user.address ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Profile',
        backgroundColor: primaryColor,
        actions: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: amber),
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                PageNavigator(ctx: context).nextPage(page: EditProfilePage());
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              label: Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (isEditing) {
                          // Implement logic to change profile picture
                        }
                      },
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: amber,
                            width: 4.0,
                          ),
                        ),
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
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: nameController,
                    icon: Icons.account_circle_outlined,
                    label: 'Nama Lengkap',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: birthdayController,
                    icon: Icons.cake,
                    label: 'Tanggal Lahir',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: phoneController,
                    icon: Icons.phone_android,
                    label: 'Nomor Telefon',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: genderController,
                    icon: Icons.man_2_outlined,
                    label: 'Jenis Kelamin',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: weightController,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Nomor Telefon',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: heightController,
                    icon: Icons.height_outlined,
                    label: 'Tinggi Badan',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: nikController,
                    icon: Icons.credit_card,
                    label: 'Nomor Induk',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: true,
                    controller: addressController,
                    icon: Icons.home_rounded,
                    label: 'Alamat',
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
