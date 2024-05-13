import 'package:clinicapp/Widgets/text_fields.dart';
import 'package:flutter/material.dart';

class CreateAppoinmentPage extends StatefulWidget {
  const CreateAppoinmentPage({super.key});

  @override
  State<CreateAppoinmentPage> createState() => _CreateAppoinmentPageState();
}

class _CreateAppoinmentPageState extends State<CreateAppoinmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Janji Temu'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [customTextField(), customTextField()],
          )),
    );
  }
}
