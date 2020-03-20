import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'db.dart';
import 'main.dart';

class CreateFamily extends StatelessWidget {
  Db db = new Db();
  String pass;
  String name;

  CreateFamily({@required this.name});

  void savetoDB() async {
    var auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      db.saveFamily(user, pass, name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Family'),
        backgroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create a new Family?',
              style: TextStyle(fontSize: 35.0, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  pass = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                  labelText: 'Enter a password',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    savetoDB();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  color: Colors.black,
                ),
                RaisedButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
