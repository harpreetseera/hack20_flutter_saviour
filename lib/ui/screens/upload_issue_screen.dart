import 'dart:io';

import 'package:flutter/material.dart';

class UploadIssueScreen extends StatefulWidget {
  UploadIssueScreen({Key key, this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  _UploadIssueScreenState createState() => _UploadIssueScreenState();
}

class _UploadIssueScreenState extends State<UploadIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categoryList = ["Garbage", "Water"];
  List<String> selectedChoices = List();

  @override
  Widget build(BuildContext context) {
    _buildChoiceList() {
      List<Widget> choices = List();
      categoryList.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: FilterChip(
            label: Text(item),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.file(
                new File(widget.imagePath),
                width: 100,
                height: 100,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Wrap(
                        children: _buildChoiceList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print("Validated");
                          }
                        },
                        child: Text('Upload'),
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
  }
}
