import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'starter_page.dart';
import 'main.dart';

class Db {
  BuildContext context;

  void saveFamily(FirebaseUser user, String pass, String name) {
    Firestore.instance
        .collection("Families")
        .document(user.email)
        .collection("Locations")
        .document(user.email)
        .setData({'latitude': 0.0, 'longitude': 0.0, 'name': name});

    print("Pass pass" + pass);
    saveFamilyPassword(user, pass);
  }

  void saveFamilyPassword(FirebaseUser user, String pass) {
    Firestore.instance
        .collection("Families")
        .document(user.email)
        .setData({'password': pass});
    saveIndividual(user, user.email);
  }

  void saveNewMember(String email, FirebaseUser user, String name) {
    Firestore.instance
        .collection("Families")
        .document(email)
        .collection("Locations")
        .document(user.email)
        .setData({'latitude': 0.0, 'longitude': 0.0, 'name': name});
    saveIndividual(user, email);
  }

  void saveIndividual(FirebaseUser user, String email) {
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .updateData({'fam_email': email});
  }

  void saveUserUpdates(String update, String famEmail, String email) {
    print(update);
    Firestore.instance
        .collection("Families")
        .document(famEmail)
        .collection("Locations")
        .document(email)
        .updateData({'update': update});
  }
}
