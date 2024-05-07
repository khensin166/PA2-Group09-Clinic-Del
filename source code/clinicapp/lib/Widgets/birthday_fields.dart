import 'package:flutter/material.dart';

class BirthdayField extends StatelessWidget {
  final TextEditingController? dateController;
  final TextEditingController? monthController;
  final TextEditingController? yearController;

  BirthdayField({
    this.dateController,
    this.monthController,
    this.yearController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              controller: dateController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'DD',
              ),
            ),
          ),
        ),
        // Month
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: monthController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: 'Month',
                hintText: 'MM',
              ),
            ),
          ),
        ),
        // Year
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Year',
                hintText: 'YYYY',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
