import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/functions/functions.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/pages/chat_screen.dart';
import 'package:kijiweni_flutter/pages/login_screen.dart';
import 'package:kijiweni_flutter/values/strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final functions = new Functions();
  User _user;
  var _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    functions.getUser().then((user) {
      if (user != null) {
        setState(() {
          _isLoggedIn = true;
//          _getUserDetails(user);
        });
      } else {
        _isLoggedIn = false;
      }
    });

    if (_isLoggedIn) {
      return new ChatPage(user: _user);
    } else {
      return new LoginPage();
    }
  }

  void _getUserDetails(FirebaseUser user) {
    var userId = user.uid;
    functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .then((document) {
      _user = User.fromSnapshot(document);
    });
  }
}
