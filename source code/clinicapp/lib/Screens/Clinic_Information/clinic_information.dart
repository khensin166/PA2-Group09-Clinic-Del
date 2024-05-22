import 'package:flutter/material.dart';

class ClinicInformation extends StatefulWidget {
  const ClinicInformation({super.key});

  @override
  State<ClinicInformation> createState() => _ClinicInformationState();
}

class _ClinicInformationState extends State<ClinicInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Klinik'),
      ),
      body: Center(
        child: Text('Clinic Information'),
      ),
    );
  }
}
