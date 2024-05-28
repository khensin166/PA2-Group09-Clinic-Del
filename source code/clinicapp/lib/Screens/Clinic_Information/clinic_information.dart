import 'package:clinicapp/Styles/colors.dart';
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
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/information.png', // Ganti dengan URL gambar klinik yang sebenarnya
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Klinik Del',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Praktek umum dokter Del resmi didirikan pada bulan Mei tahun 2009, terletak disamping pintu masuk ke area kampus Institut Teknologi Del. Tujuan didirikan praktek umum ini yang terutama adalah untuk melayani siswa, mahasiswa, pegawai Del tetapi selain itu juga untuk melayani masyarakat disekitar lingkungan kampus. Praktek umum ini bersifat sosial, non-profit, tetapi juga tetap berusaha menjaga mutu pelayanan agar sesuai dengan standar pelayanan termutakhir',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'melayani pasien-pasien yang terdaftar sebagai tanggungan Jamsostek dalam wilayah ini. Praktek umum ini bisa melayani pengobatan dasar (meliputi anak dan dewasa) hingga yang membutuhkan tindakan bedah sederhana. Di dalam praktek umum ini juga sudah tersedia obat sehingga tidak perlu membeli obat lagi di tempat lain. Saat ini praktek umum ini sedang dalam proses pengembangan menjadi klinik Yayasan Del',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dokter yang bertugas:\na. dr. Eva C. Saragih\nb. dr. Johanes Pardede (Penanggung Jawab Klinik)\nJam Pelayanan:\na. Hari: Senin – Jumat\nb. Pukul: 16.30 – 19.30',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
