import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class Chat {
  String id,
      message,
      fileUrl,
      filePath,
      createdBy,
      replyingTo,
      replyToUserId,
      username,
      userImageUrl,
      communityId,
      replyToUsername,
      replyToMessage;
  int fileStatus, fileType, createdAt, reports;

  Chat(
      {this.id,
      this.message = '',
      @required this.communityId,
      this.fileUrl,
      this.filePath,
      this.fileStatus = FILE_STATUS_NO_FILE,
      this.fileType = FILE_TYPE_NO_FILE,
      this.reports = 0,
      @required this.createdBy,
      this.username,
      this.userImageUrl,
      this.replyToUsername,
      this.replyToUserId,
      this.replyToMessage,
      this.createdAt,
      this.replyingTo})
      : assert(message != null),
        assert(fileType != null),
        assert(fileStatus != null),
        assert(communityId != null),
        assert(reports != null),
        assert(createdBy != null);

  Chat.fromSnapshot(DocumentSnapshot document)
      : id = document.documentID,
        message = document[MESSAGE_FIELD],
        communityId = document[COMMUNITY_ID_FIELD],
        fileUrl = document[FILE_URL_FIELD],
        filePath = document[FILE_PATH_FIELD],
        fileType = document[FILE_TYPE_FIELD],
        fileStatus = document[FILE_STATUS_FIELD],
        reports = document[REPORTS_FIELD],
        createdBy = document[CREATED_BY_FIELD],
        replyingTo = document[REPLYING_TO_FIELD],
        createdAt = document[CREATED_AT_FIELD];

  @override
  String toString() {
    return '''
          id: ${this.id}
          message: ${this.message}
          cratedBy: ${this.createdBy}
          createdAt: ${this.createdAt}
          communityId: ${this.communityId}
          fileUrl: ${this.fileUrl}
          filePath: ${this.filePath}
          fileType: ${this.fileType}
          fileStatus: ${this.fileStatus}
          replyingTo: ${this.replyingTo}
          reports: ${this.reports}
          ''';
  }
}
