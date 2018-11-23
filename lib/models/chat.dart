import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class Chat {
  String message, imageUrl, imagePath, imageStatus,id, createdBy, replyingTo, communityId;
  int createdAt;

  Chat(
      {this.id,
      @required this.message,
      @required this.communityId,
      this.imageUrl,
      this.imagePath,
      this.imageStatus,
      @required this.createdBy,
      this.createdAt,
      this.replyingTo})
      : assert(message != null),
        assert(communityId != null),
        assert(createdBy != null);

  Chat.fromSnapshot(DocumentSnapshot document)
      : id = document.documentID,
        message = document[MESSAGE_FIELD],
        communityId = document[COMMUNITY_ID_FIELD],
        imageUrl = document[IMAGE_URL_FIELD],
        imagePath = document[IMAGE_PATH_FIELD],
        imageStatus = document[IMAGE_STATUS_FIELD],
        createdBy = document[CREATED_BY_FIELD],
        replyingTo = document[REPLYING_TO_FIELD],
        createdAt = document[CREATED_AT_FIELD];
}
