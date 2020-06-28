import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  String id;
  String title;
  String description;
  String startDate;
  String startTime;
  String location;
  String createdBy;
  List<dynamic> users;
  String status;

  Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.startDate,
    @required this.startTime,
    @required this.location,
    @required this.createdBy,
    @required this.users,
    @required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate,
      'start_time': startTime,
      'location': location,
      'created_by': createdBy,
      'users': users,
      'status': status
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        startDate: map['start_date'],
        startTime: map['start_time'],
        location: map['location'],
        createdBy: map['created_by'],
        users: map['users'],
        status: map['status']);
  }
}
