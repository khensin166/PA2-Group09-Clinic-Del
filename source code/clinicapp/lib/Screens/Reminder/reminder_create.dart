import 'package:flutter/material.dart';

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final TextEditingController _medicineController = TextEditingController();
  int _timesPerDay = 1;
  int _days = 1;

  @override
  void dispose() {
    _medicineController.dispose();
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
              controller: _medicineController,
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
            const SizedBox(height: 16),
            const Text('Selama berapa hari?'),
            ListTile(
              title: Text('$_days Hari'),
              trailing: const Icon(Icons.arrow_drop_down),
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
            ElevatedButton(
              onPressed: () {
                // Add your save reminder logic here
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
