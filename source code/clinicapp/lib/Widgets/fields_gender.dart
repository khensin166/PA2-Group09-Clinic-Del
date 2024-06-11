import 'package:flutter/material.dart';
import 'package:clinicapp/Widgets/fields_text.dart';

class GenderFieldCustom extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final String label;

  const GenderFieldCustom({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              isExpanded: true,
              items: ['Laki-laki', 'Perempuan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
