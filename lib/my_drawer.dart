import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_family/create_family_screen.dart';
import 'login_screen.dart';
import 'become_member.dart';
import 'starter_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({@required this.name});

  final name;

  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 40.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Create a family',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateFamily()));
            },
          ),
          Center(
            child: Container(
              color: Colors.black54,
              height: 0.75,
              width: 275.0,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Become a member',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewMember()));
            },
          ),
          Center(
            child: Container(
              color: Colors.black54,
              height: 0.75,
              width: 275.0,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
