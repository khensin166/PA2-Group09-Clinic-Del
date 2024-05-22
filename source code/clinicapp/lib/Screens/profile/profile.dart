import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              DatabaseProvider().logOut(context);
            },
          ),
        ],
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
                    Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Tambahkan fungsi untuk mengedit profil di sini
                        },
                        child: const Text('Edit Profile'),
                      ),
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
                    const SizedBox(height: 20),
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
                  ],
                );
              } else {
                return Center(child: Text('No user data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
