import 'package:clinicapp/Provider/Provider_Appointment/edit_appointment_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditAppointmentPage extends StatefulWidget {
  final String? oldComplaint;
  final String? appointmentId;
  final DateTime? oldDate;
  final TimeOfDay? oldTime;

  const EditAppointmentPage({
    Key? key,
    this.oldComplaint,
    this.oldDate,
    this.oldTime,
    this.appointmentId,
  }) : super(key: key);

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  TextEditingController _complaint = TextEditingController();

  @override
  void initState() {
    super.initState();
    _complaint.text = widget.oldComplaint ?? '';
    selectedDate = widget.oldDate ?? DateTime.now();
    selectedTime = TimeOfDay.fromDateTime(widget.oldDate ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Janji Temu'),
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
                color: primaryColor,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(selectedDate),
              ),
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
                color: primaryColor,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              controller: TextEditingController(
                text: selectedTime.format(context),
              ),
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
                color: primaryColor,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _complaint,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                hintText: "Deskripsikan keluhan yang anda alami..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            Consumer<EditAppointmentProvider>(
              builder: (context, editAppointment, child) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (editAppointment.getResponse != '') {
                    showMessage(
                      message: editAppointment.getResponse,
                      context: context,
                    );

                    // Clear response message
                    editAppointment.clear();
                  }
                });
                return customButton(
                  status: editAppointment.getStatus,
                  context: context,
                  text: 'Edit',
                  tap: () {
                    if (_complaint.text.isEmpty) {
                      showMessage(
                        message: "Keluhan Harus diisi!",
                        context: context,
                      );
                    } else {
                      editAppointment.editAppointment(
                        complaint: _complaint.text.trim(),
                        context: context,
                        date: selectedDate,
                        time: selectedTime,
                        oldAppointmentId: widget.appointmentId!,
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
