import 'package:flutter/material.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool obsecureText = false,
  int? maxLines = 1,
  IconData? prefixIcon,
  bool? isHidden,
  void Function()? tootleFieldView, // Tipe data void Function()?
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: isHidden ?? false,
        decoration: InputDecoration(
          hintText: hint,
          labelText: title,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: obsecureText &&
                  tootleFieldView !=
                      null // Periksa apakah tootleFieldView tidak null
              ? InkWell(
                  onTap: () => tootleFieldView!(), // Panggil tootleFieldView
                  child: Icon(isHidden ?? false
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                )
              : null,
        ),
      ),
    ],
  );
}
