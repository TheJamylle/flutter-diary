import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/logout.dart';
import '../../models/journal.dart';
import '../common/exception_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();
  JournalService service = JournalService();

  int? userId;

  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: userId != null && userToken != null
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                  windowPage: windowPage,
                  currentDay: currentDay,
                  database: database,
                  refresh: refresh,
                  userId: userId!,
                  token: userToken!),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                onTap: () {
                  logout(context);
                },
                title: const Text('Logout'),
                leading: const Icon(Icons.logout))
          ],
        ),
      ),
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) async {
      String? token = prefs.getString('accessToken');
      String? email = prefs.getString('email');
      int? id = prefs.getInt('id');

      if (token != null && email != null && id != null) {
        setState(() {
          userId = id;
          userToken = token;
        });
        List<Journal> list =
            await service.getAll(id: id.toString(), token: token);
        setState(() {
          database = {};

          for (Journal journal in list) {
            database[journal.id] = journal;
          }
        });
      } else {
        Navigator.pushNamed(context, 'login');
      }
    }).catchError((error) {
      logout(context);
    }, test: (error) => error is TokenInvalidException).catchError((error) {
      var innerError = error as HttpException;
      showExceptionDialog(context, content: innerError.message);
    }, test: (error) => error is HttpException).catchError((error) {
      showExceptionDialog(context, content: 'Server error');
    }, test: (error) => error is TimeoutException);
  }
}
