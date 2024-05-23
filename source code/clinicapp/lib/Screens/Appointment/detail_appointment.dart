import 'package:clinicapp/Provider/Provider_Appointment/delete_appointment_provider.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage(
      {Key? key,
      this.appointmentId,
      this.complaint,
      this.statusAppointment,
      this.appointmentDate,
      this.appointmentTime})
      : super(key: key);

  final String? complaint;
  final String? appointmentId;
  final String? statusAppointment;
  final String? appointmentDate;
  final String? appointmentTime;

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi locale data untuk format tanggal
    initializeDateFormatting('id_ID', null).then((_) {
      setState(
          () {}); // Memastikan build method dipanggil ulang setelah inisialisasi
    });
  }

  String _formatDate(String? date) {
    if (date == null) return 'No Date';

    try {
      // Parse the date
      final parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      // Format the date
      return DateFormat('EEE, dd MMM yyyy', 'id_ID').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Janji Temu'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.blue, width: 1.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Konsultasi pada',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${_formatDate(widget.appointmentDate)}, ${widget.appointmentTime}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('dengan'),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.statusAppointment ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.statusAppointment == 'waiting'
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Detail Keluhan',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.complaint ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Center(
                    child: Consumer<DeleteAppointmentProvider>(
                        builder: (context, deleteAppointment, snapshot) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (deleteAppointment.getResponse != '') {
                          showMessage(
                              message: deleteAppointment.getResponse,
                              context: context);

                          // Clear the response message to avoid duplicate
                          deleteAppointment.clear();
                        }
                      });
                      return TextButton(
                        onPressed: deleteAppointment.getStatus == true
                            ? null
                            : () {
                                deleteAppointment.deleteAppointment(
                                    appointmentId: widget.appointmentId,
                                    ctx: context);
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.highlight_remove_outlined,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              'Batalkan Janji Temu',
                              style: TextStyle(color: Colors.red, fontSize: 17),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
