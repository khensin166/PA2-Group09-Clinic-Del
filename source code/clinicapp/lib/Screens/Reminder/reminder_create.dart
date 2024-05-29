import 'package:clinicapp/Provider/Provider_Reminder/add_reminder.dart';
import 'package:clinicapp/Styles/colors.dart';
import 'package:clinicapp/Styles/theme.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:clinicapp/Widgets/button_add.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final TextEditingController _medicine = TextEditingController();
  int _days = 1;
  TimeOfDay? _firstTime;
  TimeOfDay? _secondTime;
  TimeOfDay? _thirdTime;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _firstTime = const TimeOfDay(hour: 7, minute: 0); // Jam 7
    _secondTime = const TimeOfDay(hour: 13, minute: 0); // Jam 13
    _thirdTime = const TimeOfDay(hour: 19, minute: 0); // Jam 19
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
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengingat Obat'),
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
                              // const Divider(thickness: 2),
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
            Consumer<AddReminderProvider>(
                builder: (context, addReminder, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (addReminder.getResponse != '') {
                  showMessage(
                      message: addReminder.getResponse, context: context);

                  // clear respon message
                  addReminder.clear();
                }
              });
              return customButton(
                status: addReminder.getStatus,
                context: context,
                text: 'Tambah',
                tap: () {
                  if (_medicine.text.isEmpty) {
                    showMessage(
                        message: "Nama Obat Harus diisi!", context: context);
                  } else {
                    addReminder.addReminder(
                        name: _medicine.text.trim(),
                        first_time: formatTimeOfDay(_firstTime!),
                        second_time: formatTimeOfDay(_secondTime!),
                        third_time: formatTimeOfDay(_thirdTime!),
                        start_date: _date,
                        duration: _days,
                        context: context);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
