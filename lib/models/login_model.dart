import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kijiweni_flutter/models/communities_model.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'LoginModel:';

abstract class LoginModel extends Model with CommunitiesModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  StatusCode _loginStatus;
  StatusCode get loginStatus => _loginStatus;

  User _currentUser;
  User get currentUser => _currentUser;

  StatusCode _gettingCurrentUserStatus;
  StatusCode get gettingCurrentUserStatus => _gettingCurrentUserStatus;

  /// check if a user is logged in;
  Future<void> checkLoginStatus() async {
    print('$_tag at checkLoginStatus');
    final FirebaseUser user = await _auth.currentUser();
    user != null ? _isLoggedIn = true : _isLoggedIn = false;
    print('$_tag user is logged in is $_isLoggedIn');
    _checkCurrentUser();
    notifyListeners();
  }

  Future<void> _checkCurrentUser() async {
    print('$_tag at _checkCurrentUser');
    _gettingCurrentUserStatus = StatusCode.waiting;
    bool _hasError = false;

    if (_isLoggedIn) {
      final user = await _auth.currentUser();
      final userId = user.uid;
      final _currentUserDoc = await _database
          .collection(USERS_COLLECTION)
          .document(userId)
          .get()
          .catchError((error) {
        print('$_tag error on getting current user doc');
        _hasError = true;
      });
      if (_currentUserDoc.exists && !_hasError) {
        _gettingCurrentUserStatus = StatusCode.success;
        _currentUser = User.fromSnapshot(_currentUserDoc);
        print('$_tag got current user: ${_currentUser.name}');
      } else
        _gettingCurrentUserStatus = StatusCode.failed;

      updateJoinedCommunities(currentUser.id);
    } else {
      _currentUser = null;
    }
    isLoggedIn
        ? print('$_tag current user is: ${_currentUser.name}')
        : print('$_tag is not logged in, user is null');
    notifyListeners();
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('$_tag at _handleGoogleSignIn');
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print('$_tag googleUser is : $googleUser');
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('$_tag signed in as ${user.displayName}');
    return user;
  }

  Future<void> signInWithGoogle() async {
    print('$_tag at signInWithGoogle');
    _loginStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    final user = await _handleGoogleSignIn().catchError((error) {
      print('$_tag error: $error');
      _hasError = true;
    });
    if (_hasError || user == null)
      _loginStatus = StatusCode.failed;
    else {
      _loginStatus = await _checkIfUserExists(user);
      checkLoginStatus();
      //checkCurrentUser();
    }
    notifyListeners();
  }

  Future<StatusCode> _checkIfUserExists(FirebaseUser user) async {
    print('$_tag at _checkIfUserExists');
    bool _hasError = false;
    final userId = user.uid;
    final userDoc = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$_tag error on checking if user exists: $error');
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
    print('$_tag at _createUserDoc');
    bool _hasError = false;
    final username = user.displayName;
    final userId = user.uid;
    final userImageUrl = user.photoUrl;
    final createdAt = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> userDocMap = {
      NAME_FIELD: username,
      ID_FIELD: userId,
      IMAGE_URL_FIELD: userImageUrl,
      CREATED_AT_FIELD: createdAt
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .setData(userDocMap)
        .catchError((error) {
      print('$_tag error on creating user doc: $error');
      _hasError = true;
    });

    if (_hasError)
      return StatusCode.failed;
    else
      return StatusCode.success;
  }

  logout() {
    print('$_tag at logout');
    _auth.signOut();
    checkLoginStatus();
//    checkCurrentUser();
  }
}
