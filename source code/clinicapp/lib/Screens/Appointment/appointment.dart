import 'package:clinicapp/Model/appointment_model.dart';
import 'package:clinicapp/Provider/Provider_Appointment/get_appointment_service.dart';
import 'package:clinicapp/Screens/Appointment/create_appointment.dart';
import 'package:clinicapp/Screens/Appointment/local_widget/appointment_view_container.dart';
import 'package:clinicapp/Screens/Home/home.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk DateFormat

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Daftar Janji Temu',
        backgroundColor: primaryColor,
        nextPage: HomePage(),
        leadingIcon: Icons.arrow_back_ios_outlined,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<AppointmentModel>(
          future: GetUserAppointment().getAppointment(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return const Center(child: Text('Error Occurred'));
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
                          'Buat Janji Temu',
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

                    // Format date dan time
                    String formattedDate = data.date != null
                        ? DateFormat('dd-MM-yyyy').format(data.date!)
                        : 'No Date';
                    String formattedTime = data.time != null
                        ? DateFormat('HH:mm').format(data.time!)
                        : 'No Time';

                    return AppointmentCard(
                      appointmentId: data.id.toString(),
                      appointmentDate: formattedDate, // Pastikan ini String
                      appointmentTime: formattedTime, // Pastikan ini String
                      statusAppointment:
                          data.approved == null ? 'waiting' : 'approved',
                      complaint: data.complaint ?? 'No Title',
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
        tooltip: 'klik tombol ini untuk menambahkan janji temu',
        elevation: 10.0,
        onPressed: () {
          PageNavigator(ctx: context)
              .nextPage(page: const CreateAppointmentPage());
        },
        foregroundColor: black,
        label: const Text(
          'Buat Janji Temu',
        ),
        icon: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
