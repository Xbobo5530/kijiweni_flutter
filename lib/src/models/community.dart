import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:meta/meta.dart';

class Community {
  String name, id, imageUrl, imagePath, createdBy, description;
  int createdAt, lastMessageAt;

  Community(
      {@required this.name,
      this.description,
      this.id,
      this.imageUrl,
      this.imagePath,
      @required this.createdAt,
      this.lastMessageAt,
      @required this.createdBy})
      : assert(name != null),
        assert(createdAt != null),
        assert(createdBy != null);

  Community.fromSnapShot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.name = document[NAME_FIELD];
    this.description = document[DESC_FIELD];
    this.imageUrl = document[IMAGE_URL_FIELD];
    this.imagePath = document[IMAGE_PATH_FIELD];
    this.createdBy = document[CREATED_BY_FIELD];
    this.createdAt = document[CREATED_AT_FIELD];
    this.lastMessageAt = document[LAST_MESSAGE_AT_FIELD] ?? 0;
  }

  @override
  String toString() => '''
    id: ${this.id}
    name: ${this.name}
    description: ${this.description}
    imageUrl: ${this.imageUrl}
    imagePath: ${this.imagePath}
    createdBy: ${this.createdBy}
    createdAt: ${this.createdAt}
    lastMessageAt: ${this.lastMessageAt}
    
    ''';
}
