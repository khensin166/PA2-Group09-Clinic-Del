import 'package:clinicapp/Provider/Provider_Appointment/add_appointment_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({Key? key}) : super(key: key);

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _complaint = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _complaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Janji Temu'),
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
            SizedBox(height: 10),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
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
                hintText: 'Pilih Tanggal Janji Temu',
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
                hintText: 'Pilih Waktu Janji Temu',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: Icon(Icons.access_time),
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
              controller: _complaint,
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
            Consumer<AddAppointmentProvider>(
              builder: (context, addAppointment, child) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (addAppointment.getResponse != '') {
                    showMessage(
                        message: addAppointment.getResponse, context: context);

                    // clear respon message
                    addAppointment.clear();
                  }
                });
                return customButton(
                  status: addAppointment.getStatus,
                  context: context,
                  text: 'Daftar',
                  tap: () {
                    if (_complaint.text.isEmpty) {
                      showMessage(
                          message: "Keluhan Harus diisi!", context: context);
                    } else if (selectedDate == null) {
                      showMessage(
                          message: "Tanggal Harus diisi!", context: context);
                    } else if (selectedTime == null) {
                      showMessage(
                          message: "Waktu Harus diisi!", context: context);
                    } else {
                      addAppointment.addAppointment(
                        complaint: _complaint.text.trim(),
                        context: context,
                        date: selectedDate,
                        time: selectedTime,
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
