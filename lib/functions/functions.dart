import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class Functions {
  FirebaseAuth auth = FirebaseAuth.instance;
  var database = Firestore.instance;

  Future<FirebaseUser> getUser() async {
    return await auth.currentUser();
  }
}
