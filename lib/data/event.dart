import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  String id;
  String title;
  String description;
  GeoPoint location;
  String createdBy;
  List<dynamic> users;
  String status;

  Event({
    @required id,
    @required title,
    @required description,
    @required location,
    @required createdBy,
    @required users,
    @required status,
  });
}
