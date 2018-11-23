import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class User {
  String name, bio, id, imageUrl;
  int createdAt;

  User({@required this.name, this.bio, this.imageUrl, this.id, this.createdAt})
      : assert(name != null);

  User.fromSnapshot(DocumentSnapshot document)
      : name = document[NAME_FIELD],
        id = document.documentID,
        bio = document[BIO_FIELD],
        imageUrl = document[IMAGE_URL_FIELD],
        createdAt = document[CREATED_AT_FIELD];

  @override
  String toString() {
    return '''
          id: ${this.id}
          name: ${this.name}
          bio: ${this.bio}
          imageUrl: ${this.imageUrl}
          createdAt: ${this.createdAt}
          ''';
  }
}
