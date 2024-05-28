import 'package:flutter/material.dart';

class TimePickerPage extends StatefulWidget {
  @override
  _TimePickerPageState createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  TimeOfDay? _firstTime;
  TimeOfDay? _secondTime;
  TimeOfDay? _thirdTime;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _firstTime = TimeOfDay(hour: 7, minute: 0); // Jam 7
    _secondTime = TimeOfDay(hour: 13, minute: 0); // Jam 13
    _thirdTime = TimeOfDay(hour: 19, minute: 0); // Jam 19
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Picker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
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
                          _firstTime != null ? _firstTime!.format(context) : 'Pilih waktu',
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: const Icon(Icons.timer_sharp),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await _selectTime(context, _firstTime);
                            if (picked != null) {
                              setState(() {
                                _firstTime = picked;
                              });
                            }
                          },
                          child: Text(
                            'Ubah',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onTap: () async {
                          final picked = await _selectTime(context, _firstTime);
                          if (picked != null) {
                            setState(() {
                              _firstTime = picked;
                            });
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          _secondTime != null ? _secondTime!.format(context) : 'Pilih waktu',
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: const Icon(Icons.timer_sharp),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await _selectTime(context, _secondTime);
                            if (picked != null) {
                              setState(() {
                                _secondTime = picked;
                              });
                            }
                          },
                          child: Text(
                            'Ubah',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onTap: () async {
                          final picked = await _selectTime(context, _secondTime);
                          if (picked != null) {
                            setState(() {
                              _secondTime = picked;
                            });
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          _thirdTime != null ? _thirdTime!.format(context) : 'Pilih waktu',
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: const Icon(Icons.timer_sharp),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await _selectTime(context, _thirdTime);
                            if (picked != null) {
                              setState(() {
                                _thirdTime = picked;
                              });
                            }
                          },
                          child: Text(
                            'Ubah',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onTap: () async {
                          final picked = await _selectTime(context, _thirdTime);
                          if (picked != null) {
                            setState(() {
                              _thirdTime = picked;
                            });
                          }
                        },
                      ),
                      const Divider(thickness: 2),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Pilih Waktu Pengingat'),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay? initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    return picked;
  }
}
