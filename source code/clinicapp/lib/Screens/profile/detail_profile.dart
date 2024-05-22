import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:clinicapp/Widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Profile',
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<UserModel?>(
            future: Provider.of<AuthenticationProvider>(context, listen: false)
                .getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                UserModel user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage('${user.profilePicture}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nama Lengkap:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.name,
                        prefixIcon: Icons.account_circle_outlined),
                    const SizedBox(height: 20),
                    const Text(
                      'Tanggal Lahir:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.birthday,
                        prefixIcon: Icons.cake),
                    const SizedBox(height: 20),
                    const Text(
                      'Nomor Telepon:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.phone,
                        prefixIcon: Icons.phone_android),
                    const SizedBox(height: 20),
                    const Text(
                      'Jenis Kelamin:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.gender,
                        prefixIcon: Icons.man_2_outlined),
                    const SizedBox(height: 20),
                    const Text(
                      'Berat Badan:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.weight.toString(),
                        prefixIcon: Icons.monitor_weight_outlined),
                    const SizedBox(height: 20),
                    const Text(
                      'Tinggi Badan:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    customTextField(
                        readOnly: true,
                        hint: user.height.toString(),
                        prefixIcon: Icons.height_outlined),
                  ],
                );
              } else {
                return Center(
                    child: Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // DatabaseProvider().logOut(context);
                          PageNavigator(ctx: context)
                              .nextPage(page: DetailProfilePage());
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
