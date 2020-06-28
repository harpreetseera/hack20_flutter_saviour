import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saviour/data/issue.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/utils/saviour.dart';

class IssueWidget extends StatelessWidget {
  final List<Issue> nearByIssueList;
  IssueWidget({@required this.nearByIssueList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nearByIssueList.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.grey[800]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          child: CachedNetworkImage(
                            imageUrl: nearByIssueList[index].imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            placeholder: (context, url) =>
                                Container(color: Colors.blue),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.blue),
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
                                nearByIssueList[index].title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  nearByIssueList[index].description,
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
                                      "Created by: ${nearByIssueList[index].createdBy}",
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
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "${nearByIssueList[index].users.length} people are facing this issue",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    child: !nearByIssueList[index].users.contains(
                            Saviour.prefs.getString(Saviour.PREF_EMAIL))
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Are you also facing this issue?",
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
                                  var users = List<String>.from(
                                      nearByIssueList[index].users);
                                  users.add(Saviour.prefs
                                      .getString(Saviour.PREF_EMAIL));
                                  firebaseService.updateIssue(
                                      nearByIssueList[index].id, users);
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Your issue will be resolved soon...",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
