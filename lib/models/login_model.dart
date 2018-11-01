import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'LoginModel:';

abstract class LoginModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  StatusCode _loginStatus;

  StatusCode get loginStatus => _loginStatus;

  /// check if a user is logged in;
  Future<void> checkLoginStatus() async {
    final FirebaseUser user = await _auth.currentUser();
    user != null ? _isLoggedIn = true : _isLoggedIn = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('$tag at _handleGoogleSignIn');
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print('$tag googleUser is : $googleUser');
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('$tag signed in as ${user.displayName}');
    return user;
  }

  Future<void> signInWithGoogle() async {
    print('$tag at signInWithGoogle');
    _loginStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    final user = await _handleGoogleSignIn().catchError((error) {
      print('$tag error: $error');
      _hasError = true;
    });
    if (_hasError)
      _loginStatus = StatusCode.failed;
    else {
      if (user != null) {
        _loginStatus = await _checkIfUserExists(user);
      } else {
        _loginStatus = StatusCode.failed;
      }
    }
    checkLoginStatus();
    notifyListeners();
  }

  Future<StatusCode> _checkIfUserExists(FirebaseUser user) async {
    print('$tag at _checkIfUserExists');
    bool _hasError = false;
    final userId = user.uid;
    final userDoc = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on checking if user exists: $error');
      _hasError = true;
    });
    if (_hasError)
      return StatusCode.failed;
    else {
      if (userDoc.exists)
        return StatusCode.success;
      else
        return await _createUserDoc(user);
    }
  }

  Future<StatusCode> _createUserDoc(FirebaseUser user) async {
    print('$tag at _createUserDoc');
    bool _hasError = false;
    final username = user.displayName;
    final userId = user.uid;
    final userImageUrl = user.photoUrl;
    final created_at = DateTime.now().millisecondsSinceEpoch;
    // create user map
    Map<String, dynamic> userDocMap = {
      NAME_FIELD: username,
      ID_FIELD: userId,
      IMAGE_URL_FIELD: userImageUrl,
      CREATED_AT_FIELD: created_at
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .setData(userDocMap)
        .catchError((error) {
      print('$tag error on creating user doc: $error');
      _hasError = true;
    });

    if (_hasError)
      return StatusCode.failed;
    else
      return StatusCode.success;
  }

  logout() {
    print('$tag at logout');
    _auth.signOut();
    checkLoginStatus();
    notifyListeners();
  }
}
