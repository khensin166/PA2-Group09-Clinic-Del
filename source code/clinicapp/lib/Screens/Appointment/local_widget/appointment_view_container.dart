import 'package:clinicapp/Screens/Appointment/detail_appointment.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final String complaint;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final String appointmentId;
  final String statusAppointment;

  AppointmentCard({
    required this.complaint,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentId,
    required this.statusAppointment,
  });

  @override
  Widget build(BuildContext context) {
    // Format date and time
    String formattedDate = DateFormat('dd-MM-yyyy').format(appointmentDate);
    String formattedTime = appointmentTime.format(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: primaryColor),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Janji Temu', style: titleStyle),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.access_time, size: 20, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset('assets/appointmentDoctor.png'),
            ),
            title: Text(complaint),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Status: $statusAppointment',
                  style: TextStyle(
                    fontSize: 17,
                    color: statusAppointment == 'waiting'
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the detail appointment page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailsPage(
                          appointmentDate: appointmentDate,
                          appointmentTime: appointmentTime,
                          statusAppointment: statusAppointment,
                          complaint: complaint,
                          appointmentId: appointmentId,
                        ),
                      ),
                    );
                  },
                  child: Text('Lihat Detail'),
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
