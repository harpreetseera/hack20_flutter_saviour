import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saviour/data/event.dart';
import 'package:saviour/data/issue.dart';

abstract class FirebaseService {
  Future<bool> createIssue(Issue issue);
  Future<List<Issue>> getNearbyIssues();
  Future<String> uploadImage(File file);
  Future<Null> updateIssue(String id, List<String> userList);

  Future<Null> createEvent(Event event);
  Future<List<Event>> getEvents();
  Future<Null> updateEvent(String id, List<String> userList);
}

class FirebaseServiceImpl implements FirebaseService {
  var databaseReference = Firestore.instance;
  static const String KEY_ISSUES = "issues";
  static const String KEY_EVENTS = "events";

  @override
  Future<bool> createIssue(Issue issue) async {
    var res = await databaseReference.collection(KEY_ISSUES).add(issue.toMap());
    return res == null ? false : true;
  }

  @override
  Future<List<Issue>> getNearbyIssues() async {
    List<Issue> issueList = List();
    await databaseReference
        .collection(KEY_ISSUES)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => issueList.add(Issue.fromMap(f.data)));
    });
    return issueList;
  }

  @override
  Future<String> uploadImage(File image) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child(image.path.toString());
    StorageUploadTask uploadTask = reference.putFile(image);

    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    return await downloadUrl.ref.getDownloadURL();
  }

  @override
  Future<Null> updateIssue(String id, List<String> userList) async {
    await databaseReference
        .collection(KEY_ISSUES)
        .where('id', isEqualTo: id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => databaseReference
          .collection(KEY_ISSUES)
          .document(f.documentID)
          .updateData({'users': userList}));
    });
  }

  @override
  Future<Null> createEvent(Event event) async {
    var result =
        await databaseReference.collection(KEY_EVENTS).add(event.toMap());
    print(result);
  }

  @override
  Future<List<Event>> getEvents() async {
    List<Event> eventList = List();
    await databaseReference
        .collection(KEY_EVENTS)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => eventList.add(Event.fromMap(f.data)));
    });
    return eventList;
  }

  @override
  Future<Null> updateEvent(String id, List<String> userList) async {
    await databaseReference
        .collection(KEY_EVENTS)
        .where('id', isEqualTo: id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => databaseReference
          .collection(KEY_EVENTS)
          .document(f.documentID)
          .updateData({'users': userList}));
    });
  }
}
