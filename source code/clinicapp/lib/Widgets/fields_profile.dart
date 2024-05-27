import 'package:clinicapp/Widgets/fields_text.dart';
import 'package:flutter/material.dart';

class profileFieldsCustom extends StatelessWidget {
  const profileFieldsCustom({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.readOnly,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Menambahkan ini akan membuat semua anak di dalam kolom rata kiri
      children: [
        // Align(
        //   alignment: Alignment.centerLeft, // Mengatur alignment ke kiri
        //   child: Text(
        //     label,
        //     style: TextStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 8),
        customTextField(
          title: label,
          readOnly: readOnly,
          controller: controller,
          prefixIcon: icon,
        ),
      ],
    );
  }
}
