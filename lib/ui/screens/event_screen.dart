import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saviour/data/event.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/ui/screens/create_event_screen.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/utils/auth_utils.dart';
import 'package:saviour/ui/widgets/event_list_widget.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  static List<Event> eventList = [];
  final FirebaseService firebaseService = FirebaseServiceImpl();

  @override
  void initState() {
    getEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Events'),
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
      backgroundColor: Colors.blueGrey[900],
      body: Center(child: eventListWidget()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateEventScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void getEventList() async {
    List<Event> resultList = await firebaseService.getEvents();
    setState(() {
      eventList = resultList;
    });
  }

  static Widget eventListWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(FirebaseServiceImpl.KEY_EVENTS)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              new Text('Loading events'),
            ],
          ));
        List<Event> eventList = List();
        snapshot.data.documents
            .forEach((f) => eventList.add(Event.fromMap(f.data)));
        return EventListWidget(eventList: eventList);
      },
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
