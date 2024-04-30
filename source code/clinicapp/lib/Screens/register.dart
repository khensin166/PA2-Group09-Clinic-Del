import 'package:clinicapp/Provider/AuthProvider/auth_provider.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:clinicapp/Widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            customTextField(
                title: 'Username',
                controller: _username,
                hint: 'Masukkan Nama',
                obsecureText: false,
                prefixIcon: Icons.account_circle_outlined),
            const SizedBox(
              height: 20,
            ),
            customTextField(
                title: 'Password',
                controller: _password,
                hint: 'Masukkan Password',
                prefixIcon: Icons.lock,
                obsecureText: true),
            // button
            Consumer<AuthenticationProvider>(builder: (context, auth, child) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                if (auth.resMessage != '') {
                  showMessage(message: auth.resMessage, context: context);

                  // bersihkan respon agar tidaj terjadi duplikasi
                  auth.clear();
                }
              });
              return customButton(
                text: "Registrasi",
                tap: () {
                  if (_username.text.isEmpty || _password.text.isEmpty) {
                    showMessage(
                        message: "Semua kolom harus diisi", context: context);
                  } else {
                    auth.registerUser(
                        username: _username.text.trim(),
                        password: _password.text.trim(),
                        context: context);
                  }
                },
                context: context,
                status: auth.isLoading,
              );
            })
          ],
        ),
      ),
    );
  }
}
