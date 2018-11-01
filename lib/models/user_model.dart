import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'UserModel;';

abstract class UserModel extends Model {
  User _currentUser;

  User get currentUser => _currentUser;
  StatusCode _gettingCurrentUserStatus;

  StatusCode get gettingCurrentUserStatus => _gettingCurrentUserStatus;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = Firestore.instance;

  Future<void> checkCurrentUser() async {
    print('$tag at checkCurrentUser');
    _gettingCurrentUserStatus = StatusCode.waiting;
    bool _hasError = false;
    // check if is logged in
    final user = await _auth.currentUser().catchError((error) {
      print('$tag error on getting current user');
      _hasError = true;
    });

    if (user != null && !_hasError) {
      final userId = user.uid;
      var _currentUserDoc = await _database
          .collection(USERS_COLLECTION)
          .document(userId)
          .get()
          .catchError((error) {
        print('$tag error on getting current user doc');
        _hasError = true;
      });
      if (_currentUserDoc.exists && !_hasError) {
        _gettingCurrentUserStatus = StatusCode.success;
        _currentUser = User.fromSnapshot(_currentUserDoc);
        print('$tag gotten current user: ${_currentUser.username}');
      } else
        _gettingCurrentUserStatus = StatusCode.failed;
      //todo maybe sign user out or finish login

    }
    notifyListeners();
  }

  Future<User> userFromId(String userId) async {
    print('$tag at userFromId');
  }
}