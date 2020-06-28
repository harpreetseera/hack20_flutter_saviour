import 'package:flutter/material.dart';
import 'package:saviour/ui/screens/issue_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 7,
              child: Container(
                color: Colors.green,
              )),
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.yellow,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IssueScreen()));
                        },
                        color: Colors.red,
                        child: Text("Issues"),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.purple,
                        child: Text("Events"),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
