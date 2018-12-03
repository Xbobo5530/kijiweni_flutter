import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';

class JoinedCommunity {
  String id, createdBy;
  int createdAt, lastVisitAt;
  JoinedCommunity({
    this.id,
    this.createdBy,
    this.createdAt,
    this.lastVisitAt,
  });
  JoinedCommunity.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.createdBy = document[CREATED_BY_FIELD],
        this.createdAt = document[CREATED_AT_FIELD],
        this.lastVisitAt = document[LAST_VISIT_AT_FIELD];

  @override
  String toString() {
    return '''
          id: ${this.id}
          createdBy: ${this.createdBy}
          createdAt: ${this.createdAt}
          lastVisitAt: ${this.lastVisitAt}}
          ''';
  }
}
