import 'package:flutter/material.dart';

Future<bool?> showExceptionDialog(BuildContext context,
    {String title = 'Something wrong happened', required String content}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.brown),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.brown),
              )
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.brown, fontWeight: FontWeight.bold)),
            )
          ],
        );
      });
}
