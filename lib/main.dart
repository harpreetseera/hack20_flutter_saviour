import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saviour/ui/screens/home_screen.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/utils/saviour.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Saviour.prefs = await SharedPreferences.getInstance();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  setupFirebase(firebaseMessaging);
  runApp(MyApp());
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print("background data - $data");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("background notification - $notification");
  }
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

void setupFirebase(FirebaseMessaging firebaseMessaging) async {
  String firebaseToken = await firebaseMessaging.getToken();
  print('\nFirebase token : $firebaseToken\n');
  if (defaultTargetPlatform == TargetPlatform.android) {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // BlocProvider.of<AppBloc>(context).add(
        //   NotificationEvent(
        //     message: message.toString(),
        //   ),
        // );

        print("\nonMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        await Future.delayed(Duration(seconds: 5));
        // BlocProvider.of<AppBloc>(context)
        //     .add(NotificationEvent(message: message.toString()));
        print("\nonLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        await Future.delayed(Duration(seconds: 5));
        // BlocProvider.of<AppBloc>(context)
        //     .add(NotificationEvent(message: message.toString()));
        print("\nonResume: $message");
      },
    );
  }
}
