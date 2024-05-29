import 'package:clinicapp/Provider/Provider_Reminder/delete_reminder.dart';
import 'package:clinicapp/Provider/Provider_Reminder/edit_reminder.dart';
import 'package:clinicapp/Provider/Provider_Reminder/local_notification_service.dart';
import 'package:clinicapp/Widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:clinicapp/Provider/Provider_Reminder/add_reminder.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Styles/theme.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:clinicapp/Widgets/button_add.dart';

class DetailRemainderPage extends StatefulWidget {
  final int? duration;
  final String? firstTime;
  final String? secondTime;
  final String? thirdTime;
  final int? id;
  final DateTime? startDate;
  final String? name;

  const DetailRemainderPage({
    super.key,
    this.duration,
    this.firstTime,
    this.secondTime,
    this.thirdTime,
    this.id,
    this.startDate,
    this.name,
  });

  @override
  State<DetailRemainderPage> createState() => _DetailRemainderPageState();
}

class _DetailRemainderPageState extends State<DetailRemainderPage> {
  late TextEditingController _medicine;
  late int _days;
  TimeOfDay? _firstTime;
  TimeOfDay? _secondTime;
  TimeOfDay? _thirdTime;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _medicine = TextEditingController(text: widget.name);
    _days = widget.duration ?? 1;
    _firstTime = widget.firstTime != null
        ? _parseTimeOfDay(widget.firstTime!)
        : TimeOfDay(hour: 7, minute: 0);
    _secondTime = widget.secondTime != null
        ? _parseTimeOfDay(widget.secondTime!)
        : TimeOfDay(hour: 13, minute: 0);
    _thirdTime = widget.thirdTime != null
        ? _parseTimeOfDay(widget.thirdTime!)
        : TimeOfDay(hour: 19, minute: 0);
    _date = widget.startDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _medicine.dispose();
    super.dispose();
  }

  Future<void> _selectDays(BuildContext context) async {
    final int? selectedDays = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Berapa Hari'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${index + 1} Hari'),
                  onTap: () {
                    Navigator.of(context).pop(index + 1);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedDays != null) {
      setState(() {
        _days = selectedDays;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime,
      void Function(TimeOfDay) onTimePicked) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onTimePicked(picked);
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm'); // Define the desired format
    return format.format(dt);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final format = DateFormat('HH:mm');
    final dateTime = format.parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengingat Obat'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _medicine,
              decoration: const InputDecoration(
                labelText: 'Nama Obat',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Berapa Kali Sehari*',
              style: titleStyle.copyWith(color: black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kamu akan menerima notifikasi pengingat pada',
            ),
            ListTile(
              title: Text(
                  '${formatTimeOfDay(_firstTime!)}, ${formatTimeOfDay(_secondTime!)}, ${formatTimeOfDay(_thirdTime!)}'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    TimeOfDay? newFirstTime = _firstTime;
                    TimeOfDay? newSecondTime = _secondTime;
                    TimeOfDay? newThirdTime = _thirdTime;

                    return StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Waktu pengingat',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                title: Text(
                                  newFirstTime != null
                                      ? formatTimeOfDay(newFirstTime!)
                                      : 'Pilih waktu',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                leading: const Icon(Icons.timer_sharp),
                                trailing: TextButton(
                                  onPressed: () async {
                                    await _selectTime(context, newFirstTime,
                                        (picked) {
                                      setModalState(() {
                                        newFirstTime = picked;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Ubah',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                onTap: () async {
                                  await _selectTime(context, newFirstTime,
                                      (picked) {
                                    setModalState(() {
                                      newFirstTime = picked;
                                    });
                                  });
                                },
                              ),
                              const Divider(thickness: 2),
                              const SizedBox(height: 20),
                              ListTile(
                                title: Text(
                                  newSecondTime != null
                                      ? formatTimeOfDay(newSecondTime!)
                                      : 'Pilih waktu',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                leading: const Icon(Icons.timer_sharp),
                                trailing: TextButton(
                                  onPressed: () async {
                                    await _selectTime(context, newSecondTime,
                                        (picked) {
                                      setModalState(() {
                                        newSecondTime = picked;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Ubah',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                onTap: () async {
                                  await _selectTime(context, newSecondTime,
                                      (picked) {
                                    setModalState(() {
                                      newSecondTime = picked;
                                    });
                                  });
                                },
                              ),
                              const Divider(thickness: 2),
                              const SizedBox(height: 20),
                              ListTile(
                                title: Text(
                                  newThirdTime != null
                                      ? formatTimeOfDay(newThirdTime!)
                                      : 'Pilih waktu',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                leading: const Icon(Icons.timer_sharp),
                                trailing: TextButton(
                                  onPressed: () async {
                                    await _selectTime(context, newThirdTime,
                                        (picked) {
                                      setModalState(() {
                                        newThirdTime = picked;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Ubah',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                onTap: () async {
                                  await _selectTime(context, newThirdTime,
                                      (picked) {
                                    setModalState(() {
                                      newThirdTime = picked;
                                    });
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              AddButton(
                                onTap: () {
                                  setState(() {
                                    _firstTime = newFirstTime;
                                    _secondTime = newSecondTime;
                                    _thirdTime = newThirdTime;
                                  });
                                  Navigator.pop(context);
                                },
                                label: 'Simpan',
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Selama berapa hari?',
              style: titleStyle.copyWith(color: black),
            ),
            ListTile(
              title: Text('$_days Hari'),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectDays(context),
            ),
            const SizedBox(height: 16),
            const ExpansionTile(
              title: Text('Petunjuk Penggunaan'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Detail petunjuk penggunaan di sini...'),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('Bagaimana cara penggunaannya'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Detail cara penggunaan di sini...'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<EditReminderProvider>(
              builder: (context, addReminder, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (addReminder.getResponse != '') {
                    showMessage(
                      message: addReminder.getResponse,
                      context: context,
                    );

                    // clear response message
                    addReminder.clear();
                  }
                });
                return customButton(
                  status: addReminder.getStatus,
                  context: context,
                  text: 'Update',
                  tap: () {
                    if (_medicine.text.isEmpty) {
                      showMessage(
                        message: "Nama Obat Harus diisi!",
                        context: context,
                      );
                    } else {
                      addReminder.editReminder(
                        id: widget.id!,
                        name: _medicine.text.trim(),
                        first_time: formatTimeOfDay(_firstTime!),
                        second_time: formatTimeOfDay(_secondTime!),
                        third_time: formatTimeOfDay(_thirdTime!),
                        start_date: _date,
                        duration: _days,
                        context: context,
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            Consumer<DeleteReminderProvider>(
              builder: (context, deleteReminder, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (deleteReminder.getResponse != '') {
                    showMessage(
                      message: deleteReminder.getResponse,
                      context: context,
                    );

                    // clear response message
                    deleteReminder.clear();
                  }
                });
                return TextButton(
                  onPressed: deleteReminder.getStatus == true
                      ? null
                      : () async {
                          final confirmed = await showConfirmationDialog(
                            context: context,
                            content:
                                "Apakah Anda yakin ingin membatalkan janji temu?",
                            onConfirm: () {
                              deleteReminder.deleteReminder(
                                reminderId: widget.id,
                                ctx: context,
                              );
                            },
                          );
                          if (confirmed == true) {
                            // Lakukan sesuatu setelah konfirmasi
                          }
                        },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.highlight_remove_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Batalkan pengingat obat',
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
