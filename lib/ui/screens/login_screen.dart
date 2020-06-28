import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saviour/ui/widgets/signin_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              Text(
                "Saviour",
                style: GoogleFonts.fredokaOne(
                  fontSize: 50,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(height: 50),
              signInButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
