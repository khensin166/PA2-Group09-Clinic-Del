import 'package:clinicapp/Widgets/fields_text.dart';
import 'package:flutter/material.dart';

class profileFieldsCustom extends StatelessWidget {
  const profileFieldsCustom({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.readOnly,
    this.onTap,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: readOnly,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(
              title: label,
              readOnly: readOnly,
              controller: controller,
              prefixIcon: icon,
            ),
          ],
        ),
      ),
    );
  }
}