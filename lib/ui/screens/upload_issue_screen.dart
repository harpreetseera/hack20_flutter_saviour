import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saviour/data/issue.dart';
import 'package:saviour/data/location.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/utils/guid.dart';
import 'package:saviour/utils/location_util.dart';
import 'package:saviour/utils/saviour.dart';

class UploadIssueScreen extends StatefulWidget {
  UploadIssueScreen({Key key, this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  _UploadIssueScreenState createState() => _UploadIssueScreenState();
}

class _UploadIssueScreenState extends State<UploadIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categoryList = ["Garbage", "Water"];
  final FirebaseService firebaseService = FirebaseServiceImpl();
  List<String> selectedChoices = List();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _buildChoiceList() {
      List<Widget> choices = List();
      categoryList.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: FilterChip(
            label: Text(item),
            checkmarkColor: Colors.lightGreen,
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              setState(() {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);
              });
            },
          ),
        ));
      });
      return choices;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise Issue'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Image Selected for issue:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Image.file(
                    new File(widget.imagePath),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Details for issue:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Tag your issue:",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 8, 8.0),
                        child: Wrap(
                          children: _buildChoiceList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                selectedChoices.isNotEmpty) {
                              Location location =
                                  await LocationResult.getLocationNow();
                              if (location != null) {
                                showLoader();
                                firebaseService
                                    .uploadImage(new File(widget.imagePath))
                                    .then((imageUrl) async {
                                  final issue = Issue(
                                    id: Guid().generateV4(),
                                    description: descriptionController.text,
                                    title: titleController.text,
                                    imageUrl: imageUrl,
                                    tags: selectedChoices,
                                    status: "OPEN",
                                    users: [
                                      Saviour.prefs
                                              .getString(Saviour.PREF_EMAIL) ??
                                          "email_unavailable"
                                    ],
                                    location:
                                        GeoPoint(location.lat, location.long),
                                    createdBy: Saviour.prefs
                                            .getString(Saviour.PREF_EMAIL) ??
                                        "email_unavailable",
                                  );

                                  var res =
                                      await firebaseService.createIssue(issue);
                                  Navigator.of(context).pop();
                                  if (res) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Raise Issue',
                              style: TextStyle(fontSize: 20),
                            ),
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
  }

  void showLoader() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.lightGreen,
                    ),
                  ),
                  Text("Raising Issue",
                      style: TextStyle(
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
