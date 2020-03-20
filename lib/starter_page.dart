import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'create_family_screen.dart';
import 'become_member.dart';
import 'chooser_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(new MaterialApp(
      color: Colors.black,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new MyHomePage(),
        '/RegisterScreen': (BuildContext context) => new RegisterPage(),
        '/LoginScreen': (BuildContext context) => new LoginPage(),
        '/CreateFamily': (BuildContext context) => new CreateFamily(),
        '/BecomeMember': (BuildContext context) => new NewMember(),
        '/Choose': (BuildContext context) => new Chooser(),
      },
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 10);
    return new Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/family.png'),
            TypewriterAnimatedTextKit(
              speed: new Duration(milliseconds: 500),
              text: ["My Family"],
              textStyle: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
