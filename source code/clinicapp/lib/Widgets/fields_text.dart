import 'package:flutter/material.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool obsecureText = false,
  int? maxLines = 1,
  IconData? prefixIcon,
  bool? isHidden,
  bool readOnly = false,
  bool focusBorder = true,
  void Function()? tootleFieldView,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        readOnly: readOnly,
        controller: controller,
        maxLines: maxLines,
        obscureText: isHidden ?? false,
        decoration: InputDecoration(
          hintText: hint,
          labelText: title,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: focusBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: obsecureText && tootleFieldView != null
              ? InkWell(
                  onTap: () => tootleFieldView!(),
                  child: Icon(
                    isHidden ?? false
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                )
              : null,
        ),
      ),
    ],
  );
}
