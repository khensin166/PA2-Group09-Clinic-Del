import 'package:clinicapp/Provider/Provider_Reminder/add_reminder.dart';
import 'package:clinicapp/Utils/snackbar_message.dart';
import 'package:clinicapp/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  TimeOfDay? selectedTime;
  final TextEditingController _medicine = TextEditingController();
  final TextEditingController _time = TextEditingController();
  int _timesPerDay = 1;
  int _days = 1;

  @override
  void dispose() {
    _medicine.dispose();
    _time.dispose();
    super.dispose();
  }

  void _selectDays(BuildContext context) async {
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _time.text = picked.format(context); // Update _time text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengingat Obat'),
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
            const Text(
              'Berapa Kali Sehari*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return ChoiceChip(
                  label: Text('${index + 1}'),
                  selected: _timesPerDay == index + 1,
                  onSelected: (selected) {
                    setState(() {
                      _timesPerDay = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kamu akan menerima notifikasi pengingat pada',
            ),
            ListTile(
              title: Text(_time.text),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                await _selectTime(context);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Selama berapa hari?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('$_days Hari'),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectDays(context),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Petunjuk Penggunaan'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Detail petunjuk penggunaan di sini...'),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Bagaimana cara penggunaannya'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Detail cara penggunaan di sini...'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<AddReminderProvider>(
                builder: (context, addReminder, child) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                if (addReminder.getResponse != '') {
                  showMessage(
                      message: addReminder.getResponse, context: context);
                  // clear respon message
                  addReminder.clear();
                }
              });
              return SizedBox(
                width: double.infinity,
                child: customButton(
                  status: addReminder.getStatus,
                  context: context,
                  text: 'Daftar',
                  tap: () {
                    if (_medicine.text.isEmpty) {
                      showMessage(
                          message: "Nama Obat Harus diisi!", context: context);
                    } else if (selectedTime == null) {
                      showMessage(
                          message: "Waktu Harus diisi!", context: context);
                    } else {
                      addReminder.addReminder(
                          name: _medicine.text,
                          time: selectedTime,
                          frequency: _days,
                          duration: _days,
                          context: context);
                    }
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
