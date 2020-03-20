import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'become_member.dart';
import 'create_family_screen.dart';

class Chooser extends StatelessWidget {
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Family'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.black,
                labelText: 'Enter your name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'What you\'d like to do?',
              style: TextStyle(fontSize: 30.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(
                'Create a Family',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateFamily(name: name)));
              },
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(
                'Become a member',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NewMember(name: name)));
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
