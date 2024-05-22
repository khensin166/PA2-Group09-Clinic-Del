import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Profile/detail_profile.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:clinicapp/Widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    )

                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Tambahkan fungsi untuk mengedit profil di sini
                        //   },
                        //   child: const Text('Edit Profile'),
                        // ),
                        ),
                    const SizedBox(height: 30),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Nama Lengkap:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.name,
                    //     prefixIcon: Icons.account_circle_outlined),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Tanggal Lahir:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.birthday,
                    //     prefixIcon: Icons.cake),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Nomor Telepon:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.phone,
                    //     prefixIcon: Icons.phone_android),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Jenis Kelamin:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.gender,
                    //     prefixIcon: Icons.man_2_outlined),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Berat Badan:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.weight.toString(),
                    //     prefixIcon: Icons.monitor_weight_outlined),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Tinggi Badan:',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // customTextField(
                    //     readOnly: true,
                    //     hint: user.height.toString(),
                    //     prefixIcon: Icons.height_outlined),
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
                          // Handle tap
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
                        value: false, // Replace with your dark mode state
                        onChanged: (bool value) {
                          // Handle switch toggle
                        },
                      ),
                    ),
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
