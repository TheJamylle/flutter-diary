import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/exception_dialog.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;
  final TextEditingController _contentController = TextEditingController();

  AddJournalScreen({super.key, required this.journal, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
              },
              icon: const Icon(Icons.check))
        ],
        title: Text(
            "${WeekDay(journal.createdAt.weekday).long.toLowerCase()}, ${journal.createdAt.day}  |  ${journal.createdAt.month}  |  ${journal.createdAt.year}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('accessToken');
      if (token != null) {
        String content = _contentController.text;
        journal.content = content;

        JournalService service = JournalService();
        if (isEditing) {
          service
              .edit(journal.id, journal, token)
              .then((result) => Navigator.pop(context, result))
              .catchError((error) {
            logout(context);
          }, test: (error) => error is TokenInvalidException).catchError((error) {
            showExceptionDialog(context, content: 'Server error');
          }, test: (error) => error is TimeoutException);
        } else {
          service
              .register(journal, token)
              .then((result) => Navigator.pop(context, result))
              .catchError((error) {
            logout(context);
          }, test: (error) => error is TokenInvalidException).catchError((error) {
            showExceptionDialog(context, content: 'Server error');
          }, test: (error) => error is TimeoutException);
        }
      }
    });
  }
}
