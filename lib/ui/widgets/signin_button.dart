import 'package:flutter/material.dart';
import 'package:saviour/ui/screens/home_screen.dart';
import 'package:saviour/utils/auth_utils.dart';

Widget signInButton(BuildContext context) {
  return OutlineButton(
    splashColor: Colors.grey,
    onPressed: () {
      signInWithGoogle().whenComplete(() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      });
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
