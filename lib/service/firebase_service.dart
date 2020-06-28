import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saviour/data/event.dart';
import 'package:saviour/data/issue.dart';

abstract class FirebaseService {
  Future<bool> createIssue(Issue issue);
  Future<List<Issue>> getNearbyIssues();
  Future<String> uploadImage(File file);

  void createEvent(Event event);
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
  void createEvent(Event event) async {
    var result =
        await databaseReference.collection(KEY_EVENTS).add(event.toMap());
    print(result);
  }
}
