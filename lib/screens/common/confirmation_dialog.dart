import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context,
    {String title = 'Warning!',
    String content = 'Do you really want to do this operation?',
    String confirmOption = 'Confirm'}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context, false);
            }, child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(confirmOption.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.brown, fontWeight: FontWeight.bold)),
            )
          ],
        );
      });
}
