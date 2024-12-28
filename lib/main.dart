import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/journal.dart';
import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          textTheme: GoogleFonts.montserratTextTheme(),
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
              elevation: 4,
              backgroundColor: Colors.cyan[800],
              titleTextStyle: const TextStyle(color: Colors.white))),
      darkTheme: ThemeData(
          primarySwatch: Colors.cyan,
          switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(Colors.grey),
              trackColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.grey
                      : null)),
          textTheme: GoogleFonts.montserratTextTheme(),
          appBarTheme: AppBarTheme(
              elevation: 4,
              backgroundColor: Colors.cyan[800],
              titleTextStyle: const TextStyle(color: Colors.white))),
      themeMode: ThemeMode.light,
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => LoginScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["isEditing"];
          return MaterialPageRoute(builder: (context) {
            return AddJournalScreen(journal: journal, isEditing: isEditing,);
          });
        } else {
          return null;
        }
      },
    );
  }
}
