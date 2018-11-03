import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'UserModel;';

abstract class UserModel extends Model {
  final _database = Firestore.instance;

  Future<User> userFromId(String userId) async {
    print('$_tag at userFromId');
    bool _hasError = false;
    final userFromIdDoc = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$_tag error on getting use from ID');
      _hasError = true;
    });

    if (_hasError || !userFromIdDoc.exists)
      return User(name: null);
    else
      return User.fromSnapshot(userFromIdDoc);
  }
}
