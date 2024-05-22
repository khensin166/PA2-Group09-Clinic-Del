import 'package:clinicapp/Screens/Appoinment/detail_appointment.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String doctorImageUrl;
  final String taskId;

  AppointmentCard({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.doctorImageUrl,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail appointment page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailsPage(
              title: doctorName,
              appointmentId: taskId,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(doctorImageUrl),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            appointmentDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            appointmentTime,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the detail appointment page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailsPage(
                          title: doctorName,
                          appointmentId: taskId,
                        ),
                      ),
                    );
                  },
                  child: Text('Detail'),
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    primary: Colors.white,
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
