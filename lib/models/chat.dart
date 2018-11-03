import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class Chat {
  String message, chatImageUrl, id, createdBy, replyingTo, communityId;
  int createdAt;

  Chat(
      {@required this.message,
      @required this.communityId,
      this.chatImageUrl,
      this.id,
      @required this.createdBy,
      this.replyingTo})
      : assert(message != null),
        assert(communityId != null),
        assert(createdBy != null);

  Chat.fromSnapshot(var value)
      : message = value[MESSAGE_FIELD],
        communityId = value[COMMUNITY_ID_FIELD],
        chatImageUrl = value[CHAT_IMAGE_URL_FIELD],
        id = value[ID_FIELD],
        createdBy = value[CREATED_BY_FIELD],
        replyingTo = value[REPLYING_TO_FIELD],
        createdAt = value[CREATED_AT_FIELD];
}
