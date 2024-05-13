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
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();

  int _selectedDormId = 1;
  bool _isHidden = true;
  bool _isHidden2 = true;

  var dormValues = {
    "Pniel": 1,
    "Jati": 2,
    "Rusun 4": 3,
    "Nazareth": 4,
    "Silo": 5,
    "Kapernaum": 6,
    "Mambri": 7,
  };

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
                title: 'Nama Lengkap',
                controller: _fullname,
                hint: 'Jhon Doe',
                obsecureText: false,
                prefixIcon: Icons.account_circle_outlined,
                isHidden: false),
            const SizedBox(
              height: 20,
            ),
            customTextField(
                title: 'Username',
                controller: _username,
                hint: 'JhonDoe12',
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
            const SizedBox(
              height: 20,
            ),

            customTextField(
                title: 'Konfirmasi Password',
                controller: _passwordConfirmation,
                hint: 'Konfirmasi password',
                prefixIcon: Icons.lock,
                obsecureText: true,
                isHidden: _isHidden2,
                tootleFieldView: _tootleFieldViewConfirmation),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<int>(
              value: _selectedDormId,
              onChanged: (newValue) {
                setState(() {
                  _selectedDormId = newValue!;
                });
              },
              items: dormValues.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Dorm Name',
              ),
            ),
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
                      passwordConfirmation: _passwordConfirmation.text.trim(),
                      fullname: _fullname.text.trim(),
                      context: context,
                      dorm: _selectedDormId,
                    );
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

  void _tootleFieldView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _tootleFieldViewConfirmation() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}
