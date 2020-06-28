import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saviour/data/issue.dart';
import 'package:saviour/service/firebase_service.dart';
import 'package:saviour/ui/screens/login_screen.dart';
import 'package:saviour/ui/screens/upload_issue_screen.dart';
import 'package:saviour/ui/widgets/issue_widget.dart';
import 'package:saviour/utils/auth_utils.dart';
import 'package:saviour/utils/saviour.dart';

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
    if (index != 1) {
      getMyIssues();
      setState(() {
        _selectedIndex = index;
      });
    }
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
      final pickedFile =
          await picker.getImage(source: imageSource, imageQuality: 50);
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
                      leading: new Icon(
                        Icons.camera,
                        color: Colors.lightGreen,
                      ),
                      title: new Text(
                        'Take from camera',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => {
                            Navigator.pop(context),
                            getImage(ImageSource.camera),
                          }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo,
                      color: Colors.lightGreen,
                    ),
                    title: new Text(
                      'Choose from gallery',
                      style: TextStyle(color: Colors.white),
                    ),
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
        centerTitle: true,
        title: Text(_selectedIndex == 0
            ? 'All Issues'
            : _selectedIndex == 2 ? 'My Issues' : ''),
        elevation: 0.5,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {
                'Logout',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showImagePickerSheet();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            title: Text('All Issues'),
          ),
          BottomNavigationBarItem(
            icon: Icon(null),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('My Issues'),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.blueGrey[900],
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey[400],
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
      stream: Firestore.instance
          .collection('issues')
          .where('created_by',
              isEqualTo: Saviour.prefs.getString(Saviour.PREF_EMAIL))
          .snapshots(),
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

  void handleClick(String value) async {
    if (value == 'Logout') {
      var res = await signOutGoogle();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('/'),
      );
    } else if (value == 'Settings') {}
  }
}
