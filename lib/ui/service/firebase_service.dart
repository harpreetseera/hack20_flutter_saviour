import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseService {
  final databaseReference = Firestore.instance;
  static const String KEY_ISSUES = "issues";

  void createIssue(args) async {
    await databaseReference.collection(KEY_ISSUES).add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
  }

  void getData() {
    databaseReference
        .collection(KEY_ISSUES)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }
}
