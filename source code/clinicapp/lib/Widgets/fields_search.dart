
import 'package:flutter/material.dart';

class searchFields extends StatelessWidget {
  const searchFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 20,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Cari Obat dan Article...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
