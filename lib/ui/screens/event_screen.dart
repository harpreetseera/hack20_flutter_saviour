import 'package:flutter/material.dart';
import 'package:saviour/ui/screens/create_event_screen.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/utils/auth_utils.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Events"),
        elevation: 0.5,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout',}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(child: Text("Event Screen")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateEventScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
    );
  }

  void handleClick(String value) async {
    if (value == 'Logout') {
      var res = await signOutGoogle();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('/'),
      );
    } else if (value == 'Settings') {}
  }
}
