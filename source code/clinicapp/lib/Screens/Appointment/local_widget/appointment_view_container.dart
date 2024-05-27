import 'package:clinicapp/Screens/Appointment/detail_appointment.dart';
import 'package:clinicapp/Styles/colors.dart';
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
    // Format date dan time
    String formattedDate = DateFormat('dd-MM-yyyy').format(appointmentDate);
    String formattedTime = appointmentTime.format(context);

    return GestureDetector(
      onTap: () {
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaint,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: null, // Allow the text to wrap to multiple lines
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 20, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                'Status: $statusAppointment',
                style: TextStyle(
                  fontSize: 17,
                  color: statusAppointment == 'waiting'
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
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
                      foregroundColor: Colors.white
                      
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
