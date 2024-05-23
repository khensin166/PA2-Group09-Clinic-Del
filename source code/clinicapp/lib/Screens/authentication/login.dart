import 'package:clinicapp/Provider/Provider_Auth/auth_provider.dart';
import 'package:clinicapp/Screens/Authentication/register.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:clinicapp/Widgets/fields_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isHidden = true;

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
        title: Text('Login'),
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
                hint: 'Terdiri dari huruf dan angka',
                prefixIcon: Icons.lock,
                obsecureText: true,
                isHidden: _isHidden,
                tootleFieldView: _tootleFieldView),
            // button
            Consumer<AuthenticationProvider>(builder: (context, auth, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (auth.resMessage != '') {
                  showMessage(message: auth.resMessage, context: context);

                  // Clear the response message to avoid duplicate
                  auth.clear();
                }
              });
              return customButton(
                text: 'Login',
                tap: () {
                  if (_username.text.isEmpty || _password.text.isEmpty) {
                    showErrorMessage(
                        message: "Semua kolom harus di isi", context: context);
                  } else {
                    auth.loginUser(
                        username: _username.text.trim(),
                        password: _password.text.trim(),
                        context: context);
                  }
                },
                context: context,
                status: auth.isLoading,
              );
            }),
            TextButton(
                onPressed: () {
                  PageNavigator(ctx: context)
                      .nextPage(page: const RegisterPage());
                },
                child: const Text('registrasi'))
          ],
        ),
      ),
    );
  }

  void _tootleFieldView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
