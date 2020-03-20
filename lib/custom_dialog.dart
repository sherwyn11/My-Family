import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'db.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, famEmail;
  String message;
  final Image image;
  Db db = new Db();

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    @required this.famEmail,
    this.image,
  });

  void saveUpdates() async {
    String myEmail = await FirebaseAuth.instance.currentUser().then((value) {
      db.saveUserUpdates(message, famEmail, value.email);
      return value.email;
    });
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  message = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: description,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    saveUpdates();
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            child: Icon(
              Icons.message,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
