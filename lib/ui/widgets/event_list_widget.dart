import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saviour/data/event.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/utils/saviour.dart';

class EventListWidget extends StatelessWidget {
  final List<Event> eventList;
  EventListWidget({@required this.eventList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.grey[800]),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          color: Colors.grey[200],
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                DateFormat.d().format(DateFormat("yMMMd")
                                    .parse(eventList[index].startDate)),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                DateFormat.MMM().format(DateFormat("yMMMd")
                                    .parse(eventList[index].startDate)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                eventList[index].title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  eventList[index].description,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Wrap(
                                  children: <Widget>[
                                    Text(
                                      "Created by: ${eventList[index].createdBy}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.timer),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "${eventList[index].startDate}  ${eventList[index].startTime}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: !eventList[index].users.contains(
                            Saviour.prefs.getString(Saviour.PREF_EMAIL))
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Would like to join?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  FirebaseService firebaseService =
                                      FirebaseServiceImpl();
                                  var users = List<String>.from(eventList[index].users);
                                  users.add(Saviour.prefs
                                      .getString(Saviour.PREF_EMAIL));
                                  firebaseService.updateEvent(
                                      eventList[index].id, users);
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Thanks for showing interest",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
