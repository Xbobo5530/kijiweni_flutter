import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kijiweni_flutter/functions/functions.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/pages/chat_screen.dart';
import 'package:kijiweni_flutter/values/strings.dart';

class LoginPage extends StatelessWidget {
  final functions = Functions();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: Center(
        child: RaisedButton(
            child: Text(googleSignInText),
            onPressed: () => _signInWithGoogle(context)),
      ),
    );
  }

  _signInWithGoogle(BuildContext context) {
    _handleGoogleSignIn().then((FirebaseUser user) {
      print(user);

      var userId = user.uid;
      functions.database
          .collection(USERS_COLLECTION)
          .document(userId)
          .get()
          .then((document) {
        if (document.exists) {
          User user = User.fromSnapshot(document);
          user != null
              ? Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ChatPage(user: user)))
              : new CircularProgressIndicator();
        }
      });
    }).catchError((e) => print(e));
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    print('signed in ${user.displayName}');
    return user;
  }
}
