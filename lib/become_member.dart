import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'db.dart';
import 'main.dart';

class NewMember extends StatelessWidget {
  String email, pass, name;
  var _db = Firestore.instance;
  Db db = new Db();
  FirebaseUser curr;
  var fin;

  NewMember({@required this.name});

  void savetoDB() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      curr = user;
      fin = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) {
        return value.data['fname'];
      });
    });

    var doc = await _db.collection("Families").document(email).get();
    var check = doc.data['password'];
    if (check == pass) {
      print("Correct password!");
      db.saveNewMember(email, curr, fin);
    } else {
      print("Invalid password!");
    }
  }

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
            child: Text(
              'Become a new member?',
              style: TextStyle(fontSize: 30.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.black,
                labelText: 'Family head email',
              ),
            ),
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
                labelText: 'Enter family password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                savetoDB();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
