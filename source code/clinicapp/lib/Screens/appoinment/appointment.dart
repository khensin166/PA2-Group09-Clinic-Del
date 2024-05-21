import 'package:clinicapp/Model/appointment_model.dart';
import 'package:clinicapp/Provider/AppointmentProvider/get_appointment_service.dart';
import 'package:clinicapp/Screens/Appoinment/create_appointment.dart';
import 'package:clinicapp/Screens/Appoinment/local_widget/appointment_view_container.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Janji Temu'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<AppointmentModel>(
          future: GetUserAppointment().getAppointment(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return const Center(child: Text('Error Ocurred'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              if (snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Anda belum memiliki Janji Temu',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          PageNavigator(ctx: context)
                              .nextPage(page: const CreateAppointmentPage());
                        },
                        child: Text(
                          'Create an appointment ',
                          style: TextStyle(fontSize: 18, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.data![index];
                    return AppointmentField(
                      initial: "${index + 1}",
                      title: data.complaint ?? 'No Title',
                      subtitle: data.time?.toString() ?? 'No Time',
                      isCompleted: false,
                      taskId: data.id.toString(),
                    );
                  },
                );
              }
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'klik tombol ini unutuk menambahkan janji temu',
        elevation: 10.0,
        onPressed: () {
          PageNavigator(ctx: context)
              .nextPage(page: const CreateAppointmentPage());
        },
        foregroundColor: black,
        label: const Text('Buat Janji Temu'),
        icon: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
