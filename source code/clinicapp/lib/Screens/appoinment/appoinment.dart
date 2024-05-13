import 'package:clinicapp/Screens/appoinment/create_appoinment.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  List appoiment = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Janji Temu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: appoiment.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum ada Appoiment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            : ListView(
                children: List.generate(5, (index) {
                  return Text("data");
                }),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PageNavigator(ctx: context)
              .nextPage(page: const CreateAppoinmentPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
