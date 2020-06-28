import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saviour/data/issue.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/ui/widgets/home_widget.dart';
import 'package:saviour/ui/screens/upload_issue_screen.dart';

class IssueScreen extends StatefulWidget {
  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  int _selectedIndex = 0;
  static List<Issue> nearbyIssueList = [];
  static List<Issue> myIssueList = [];

  final FirebaseService firebaseService = FirebaseServiceImpl();
  List<Widget> _widgetOptions = <Widget>[
    nearByIssueWidget(),
    Offstage(),
    myIssuesWidget(),
  ];

  void _onItemTapped(int index) {
    getMyIssues();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getNearbyIssueList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    Future getImage(ImageSource imageSource) async {
      final pickedFile = await picker.getImage(source: imageSource);
      if (pickedFile == null) return;
      if (pickedFile.path == null) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return UploadIssueScreen(imagePath: pickedFile.path);
          },
        ),
      );
    }

    _showImagePickerSheet() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.camera),
                      title: new Text('Take from camera'),
                      onTap: () => {
                            Navigator.pop(context),
                            getImage(ImageSource.camera),
                          }),
                  new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Choose from gallery'),
                    onTap: () => {
                      Navigator.pop(context),
                      getImage(ImageSource.gallery),
                    },
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saviour'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showImagePickerSheet();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(null),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void getNearbyIssueList() async {
    List<Issue> resultList = await firebaseService.getNearbyIssues();
    setState(() {
      nearbyIssueList = resultList;
    });
  }

  void getMyIssues() async {
    List<Issue> resultList = await firebaseService.getNearbyIssues();
    setState(() {
      myIssueList = resultList;
    });
  }

  static Widget nearByIssueWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('issues').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              new Text('Loading nearby issues'),
            ],
          ));
        List<Issue> issueList = List();
        snapshot.data.documents
            .forEach((f) => issueList.add(Issue.fromMap(f.data)));
        return IssueWidget(nearByIssueList: issueList);
      },
    );
  }

  static Widget myIssuesWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('issues').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              new Text('Loading your issues'),
            ],
          ));
        List<Issue> issueList = List();
        snapshot.data.documents
            .forEach((f) => issueList.add(Issue.fromMap(f.data)));
        return IssueWidget(nearByIssueList: issueList);
      },
    );
  }
}
