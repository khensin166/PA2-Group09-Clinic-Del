import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String content,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Tutup dialog dengan nilai false
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                onConfirm(); // Panggil fungsi onConfirm
                Navigator.of(context)
                    .pop(true); // Tutup dialog dengan nilai true
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }