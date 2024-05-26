import 'dart:io';

import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Provider_Profile/get_profile_provider.dart';
import 'package:clinicapp/Provider/Provider_Profile/update_profile_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:clinicapp/Widgets/fields_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// final imageUserProfile = ImageUserProfile();

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;

  late UserModel user = UserModel();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController birthdayController = TextEditingController();
  late TextEditingController nikController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController genderController = TextEditingController();
  late TextEditingController weightController = TextEditingController();
  late TextEditingController heightController = TextEditingController();
  late TextEditingController addressController = TextEditingController();

// fungsi mengambil data ketika
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
        leading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: nameController,
                    icon: Icons.account_circle_outlined,
                    label: 'Nama Lengkap',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: birthdayController,
                    icon: Icons.cake,
                    label: 'Tanggal Lahir',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: phoneController,
                    icon: Icons.phone_android,
                    label: 'Nomor Telefon',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: genderController,
                    icon: Icons.man_2_outlined,
                    label: 'Jenis Kelamin',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: weightController,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Nomor Telefon',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: heightController,
                    icon: Icons.height_outlined,
                    label: 'Tinggi Badan',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: nikController,
                    icon: Icons.credit_card,
                    label: 'Nomor Induk',
                  ),
                  const SizedBox(height: 20),
                  profileFieldsCustom(
                    readOnly: false,
                    controller: addressController,
                    icon: Icons.home_rounded,
                    label: 'Alamat',
                  ),
                  SizedBox(height: 30),
                  Consumer<UpdateProfileProvider>(
                    builder: (context, updateProfile, child) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (updateProfile.getResponse != '') {
                          showMessage(
                              message: updateProfile.getResponse,
                              context: context);

                          // clear respon message
                          updateProfile.clear();
                        }
                      });
                      return customButton(
                        status: updateProfile.getStatus,
                        context: context,
                        text: 'Update',
                        tap: () {
                          if (nameController.text.isEmpty) {
                            showMessage(
                                message: "Nama harus diisi!", context: context);
                          } else if (birthdayController.text.isEmpty) {
                            showMessage(
                                message: "Tanggal lahir harus diisi!",
                                context: context);
                          } else if (nikController.text.isEmpty) {
                            showMessage(
                                message: "NIK harus diisi!", context: context);
                          } else if (phoneController.text.isEmpty) {
                            showMessage(
                                message: "Nomor telepon harus diisi!",
                                context: context);
                          } else if (genderController.text.isEmpty) {
                            showMessage(
                                message: "Jenis kelamin harus diisi!",
                                context: context);
                          } else if (weightController.text.isEmpty) {
                            showMessage(
                                message: "Berat badan harus diisi!",
                                context: context);
                          } else if (heightController.text.isEmpty) {
                            showMessage(
                                message: "Tinggi badan harus diisi!",
                                context: context);
                          } else if (addressController.text.isEmpty) {
                            showMessage(
                                message: "Alamat harus diisi!",
                                context: context);
                          } else {
                            updateProfile.UpdateProfile(
                              name: nameController.text,
                              birthday: birthdayController.text,
                              nik: nikController.text,
                              phone: phoneController.text,
                              gender: genderController.text,
                              weight: weightController.text,
                              height: heightController.text,
                              address: addressController.text,
                              context: context,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
