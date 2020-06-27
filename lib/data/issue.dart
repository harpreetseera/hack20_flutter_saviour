import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Issue {
  String id;
  String imageUrl;
  String title;
  String description;
  GeoPoint location;
  String createdBy;
  List<dynamic> users;
  String status;
  List<dynamic> tags;

  Issue({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
    @required this.createdBy,
    @required this.id,
    @required this.location,
    @required this.users,
    @required this.tags,
    @required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': imageUrl,
      'title': title,
      'description': description,
      'location': location,
      'created_by': createdBy,
      'users': users,
      'status': status,
      'tags': tags
    };
  }

  static Issue fromMap(Map<String, dynamic> map) {
    return Issue(
        id: map['id'],
        imageUrl: map['image'],
        title: map['title'],
        description: map['description'],
        location: map['location'],
        createdBy: map['created_by'],
        users: map['users'],
        status: map['status'],
        tags: map['tags']);
  }
}
