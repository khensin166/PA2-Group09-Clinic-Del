import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, String>> history = [
    {
      'title': 'Demam Tinggi',
      'date': 'Jul 10, 2023',
      'prescription':
          'Sanmol 500 grm (3x1)\nNeurobion Biru (3 x 1)\nParacetamol (3 x 1)',
    },
    {
      'title': 'Demam Tinggi',
      'date': 'Jul 10, 2023',
      'prescription':
          'Sanmol 500 grm (3x1)\nNeurobion Biru (3 x 1)\nParacetamol (3 x 1)',
    },
    {
      'title': 'Demam Tinggi',
      'date': 'Jul 10, 2023',
      'prescription':
          'Sanmol 500 grm (3x1)\nNeurobion Biru (3 x 1)\nParacetamol (3 x 1)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Penyakit'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history[index]['title']!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    history[index]['date']!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Resep Obat :',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    history[index]['prescription']!,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
