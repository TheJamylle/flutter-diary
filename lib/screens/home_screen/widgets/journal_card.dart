import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';

import '../../../helpers/logout.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final int userId;
  final String token;

  const JournalCard(
      {Key? key,
      this.journal,
      required this.userId,
      required this.token,
      required this.showedDate,
      required this.refreshFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      print(journal);
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, showedDate, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt.weekday).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, showedDate);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate.weekday).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  callAddJournalScreen(BuildContext context, DateTime date,
      {Journal? journal}) {
    Journal localJournal = Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: date,
        updatedAt: date,
        userId: userId);

    Map<String, dynamic> map = {};
    map['isEditing'] = false;

    if (journal != null) {
      localJournal = journal;
      map['isEditing'] = true;
    }

    map['journal'] = localJournal;

    Navigator.pushNamed(context, 'add-journal', arguments: map).then((value) {
      if (value != null && value == true) {
        refreshFunction();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registrado com sucesso'),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  removeJournal(BuildContext context) {
    JournalService service = JournalService();

    if (journal != null) {
      showConfirmationDialog(context,
              content:
                  'Deseja realmente remover essa nota do dia ${journal!.createdAt}?',
              confirmOption: 'Remover')
          .then((value) => {
                if (value != null)
                  {
                    if (value)
                      {
                        service.delete(journal!.id, token).then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Deletado com sucesso'),
                            backgroundColor: Colors.green,
                          ));
                          refreshFunction();
                        })
                      }
                  }
              })
          .catchError((error) {
        logout(context);
      }, test: (error) => error is TokenInvalidException);
    }
  }
}
