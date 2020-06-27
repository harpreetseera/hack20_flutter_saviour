import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saviour/data/model/near_by_issue.dart';
import 'package:saviour/ui/widgets/home_widget.dart';
import 'package:saviour/ui/screens/upload_issue_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomeWidget(
      nearByIssueList: [
        NearByIssue(
            imageUrl:
                "https://static.toiimg.com/photo/msid-69771713/69771713.jpg?64652",
            title: "title",
            subTitle: "subTitle"),
        NearByIssue(
            imageUrl:
                "https://static.toiimg.com/photo/msid-69771713/69771713.jpg?64652",
            title: "title",
            subTitle: "subTitle"),
        NearByIssue(
            imageUrl:
                "https://static.toiimg.com/photo/msid-69771713/69771713.jpg?64652",
            title: "title",
            subTitle: "subTitle"),
        NearByIssue(
            imageUrl:
                "https://static.toiimg.com/photo/msid-69771713/69771713.jpg?64652",
            title: "title",
            subTitle: "subTitle"),
        NearByIssue(
            imageUrl:
                "https://static.toiimg.com/photo/msid-69771713/69771713.jpg?64652",
            title: "title",
            subTitle: "subTitle"),
      ],
    ),
    // Text(
    //   'Index 1: Upload',
    //   style: optionStyle,
    // ),
    Text(
      'Index 2: Events',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saviour'),
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
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
}
