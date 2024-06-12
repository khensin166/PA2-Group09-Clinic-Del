import 'package:flutter/material.dart';

class ClinicInformation extends StatefulWidget {
  const ClinicInformation({super.key});

  @override
  State<ClinicInformation> createState() => _ClinicInformationState();
}

class _ClinicInformationState extends State<ClinicInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Klinik'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://example.com/clinic_image.jpg', // Replace with your image URL
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nama Klinik: Klinik Sehat Selalu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Alamat: Jalan Sehat No. 123, Kota Sejahtera',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Telepon: (021) 123-4567',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Jam Operasional:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Senin - Jumat: 08.00 - 17.00\nSabtu: 08.00 - 12.00\nMinggu: Tutup',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tentang Klinik:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Klinik Sehat Selalu menyediakan berbagai layanan kesehatan berkualitas untuk masyarakat. Dengan tenaga medis profesional dan peralatan medis modern, kami siap melayani kebutuhan kesehatan Anda.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
