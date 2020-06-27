import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Saviour',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Saviour.prefs.getString(Saviour.PREF_LOGGED_IN) ?? false
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
