import 'package:clinicapp/Provider/Provider_Appointment/delete_appointment_provider.dart';
import 'package:clinicapp/Screens/Appointment/edit_appointment.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/app_bar.dart';
import 'package:clinicapp/Widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({
    Key? key,
    required this.appointmentId,
    required this.complaint,
    required this.statusAppointment,
    required this.appointmentDate,
    required this.appointmentTime,
  }) : super(key: key);

  final String complaint;
  final String appointmentId;
  final String statusAppointment;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  String? formattedDate;
  String? formattedTime;

  @override
  void initState() {
    super.initState();
    // Inisialisasi locale data untuk format tanggal
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        formattedDate = DateFormat('dd-MM-yyyy').format(widget.appointmentDate);
        formattedTime = widget.appointmentTime.format(context);
      });
    });
  }

  String _formatDate(String date) {
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
    // Check if formattedDate and formattedTime are initialized
    if (formattedDate == null || formattedTime == null) {
      return Scaffold(
        appBar: AppBarCustom(
          title: 'Detail Janji Temu',
          backgroundColor: primaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditAppointmentPage(
                    appointmentId: widget.appointmentId,
                    oldComplaint: widget.complaint,
                    oldDate: widget.appointmentDate,
                    oldTime: widget.appointmentTime,
                  ),
                ));
              },
            )
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Detail Janji Temu',
        backgroundColor: primaryColor,
        leading: true,
        actions: [
          widget.statusAppointment == "waiting"
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: amber),
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextButton.icon(
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        context: context,
                        content: "Apakah Anda yakin ingin mengubah janji temu?",
                        onConfirm: () {
                          // Tidak ada tindakan khusus di sini
                        },
                      );
                      if (confirmed == true) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditAppointmentPage(
                            appointmentId: widget.appointmentId,
                            oldComplaint: widget.complaint,
                            oldDate: widget.appointmentDate,
                            oldTime: widget.appointmentTime,
                          ),
                        ));
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
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
                    '${_formatDate(formattedDate!)}, $formattedTime',
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
                    widget.statusAppointment,
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
                    widget.complaint,
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
                            : () async {
                                final confirmed = await showConfirmationDialog(
                                  context: context,
                                  content:
                                      "Apakah Anda yakin ingin membatalkan janji temu?",
                                  onConfirm: () {
                                    deleteAppointment.deleteAppointment(
                                      appointmentId: widget.appointmentId,
                                      ctx: context,
                                    );
                                  },
                                );
                                if (confirmed == true) {
                                  // Lakukan sesuatu setelah konfirmasi
                                }
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
