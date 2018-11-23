import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class Chat {
  String id, message, fileUrl, filePath,  createdBy, replyingTo, communityId;
  int fileStatus, fileType,createdAt;

  Chat(
      {this.id,
      @required this.message,
      @required this.communityId,
      this.fileUrl,
      this.filePath,
      this.fileStatus,
      this.fileType,
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
         fileUrl = document[FILE_URL_FIELD],
        filePath = document[FILE_PATH_FIELD],
        fileType = document[FILE_TYPE_FIELD],
        fileStatus = document[FILE_STATUS_FIELD],
        createdBy = document[CREATED_BY_FIELD],
        replyingTo = document[REPLYING_TO_FIELD],
        createdAt = document[CREATED_AT_FIELD];
}
