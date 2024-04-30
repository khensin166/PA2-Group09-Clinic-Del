import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTextField(
    {String? title,
    String? hint,
    TextEditingController? controller,
    bool obsecureText = false,
    int? maxLines = 1,
    IconData? prefixIcon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
        child: Text(
          title!,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obsecureText,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            border: InputBorder.none,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: obsecureText
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                        obsecureText ? Icons.visibility : Icons.visibility_off))
                : null,
          ),
        ),
      )
    ],
  );
}
