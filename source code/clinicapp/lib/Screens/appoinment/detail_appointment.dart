import 'package:clinicapp/Provider/AppointmentProvider/delete_appointment_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({Key? key, this.title, this.appointmentId})
      : super(key: key);

  final String? title;
  final String? appointmentId;

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _complaintController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _complaintController.text = widget.title!;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _complaintController.dispose();
    super.dispose();
    // digunakan untuk membersihkan sumber daya yang digunakan oleh widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Janji Temu'),
        actions: [
          Consumer<DeleteAppointmentProvider>(
              builder: (context, deleteAppointment, child) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (deleteAppointment.getResponse != '') {
                showMessage(
                    message: deleteAppointment.getResponse, context: context);

                // Clear the respon message to avoid duplicate
                deleteAppointment.clear();
              }
            });
            return IconButton(
                onPressed: deleteAppointment.getStatus == true
                    ? null
                    : () {
                        deleteAppointment.deleteAppointment(
                            appointmentId: widget.appointmentId, ctx: context);
                      },
                icon: Icon(
                  Icons.delete,
                  color: deleteAppointment.getStatus == true ? grey : white,
                ));
          })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Tanggal*',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: primaryColor),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    _dateController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
              decoration: InputDecoration(
                hintText: '02 February 2024',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Waktu*',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: primaryColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
              decoration: InputDecoration(
                hintText: '10:00 AM', // Atur teks petunjuk sesuai kebutuhan
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: Icon(Icons.access_time), // Ganti ikon jam
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Keluhan*',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: primaryColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _complaintController,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                hintText: "Deskripsikan keluhan yang anda alami..",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 30),
            // customButton(context: context, text: 'Update', status: false),
          ],
        ),
      ),
    );
  }
}
