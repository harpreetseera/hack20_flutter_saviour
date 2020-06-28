import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saviour/ui/screens/home_screen.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/utils/saviour.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Saviour.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Saviour',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.blueGrey[900],
        accentColor: Colors.greenAccent[700],
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home: Saviour.prefs.getBool(Saviour.PREF_LOGGED_IN) ?? false
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
