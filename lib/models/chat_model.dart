import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ChatModel:';

abstract class ChatModel extends Model {
  Firestore _database = Firestore.instance;

  StatusCode _sendingMessageStatus;

  StatusCode get sendingMessageStatus => _sendingMessageStatus;

  Stream<dynamic> communityChatStream(Community community) {
    return _database
        .collection(COMMUNITIES_COLLECTION)
        .document(community.id)
        .collection(CHATS_COLLECTION)
        .snapshots();
  }

  Future<StatusCode> sendMessage(Chat chat) async {
    print('$_tag at sendMessage');
    _sendingMessageStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    // make chat map
    Map<String, dynamic> chatMap = Map();
    if (chat.message != null)
      chatMap.putIfAbsent(MESSAGE_FIELD, () => chat.message);
    if (chat.communityId != null)
      chatMap.putIfAbsent(COMMUNITY_ID_FIELD, () => chat.communityId);
    if (chat.createdBy != null)
      chatMap.putIfAbsent(CREATED_BY_FIELD, () => chat.createdBy);
    if (chat.replyingTo != null)
      chatMap.putIfAbsent(REPLYING_TO_FIELD, () => chat.replyingTo);
    if (chat.chatImageUrl != null)
      chatMap.putIfAbsent(CHAT_IMAGE_URL_FIELD, () => chat.chatImageUrl);
    chatMap.putIfAbsent(
        CREATED_AT_FIELD, () => DateTime.now().millisecondsSinceEpoch);

    await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(chat.communityId)
        .collection(CHATS_COLLECTION)
        .add(chatMap)
        .catchError((error) {
      print('$_tag error on adding new chat: $error');
      _hasError = true;
      _sendingMessageStatus = StatusCode.failed;
      notifyListeners();
    });

    if (_hasError)
      return StatusCode.failed;
    else {
      _sendingMessageStatus = StatusCode.success;
      notifyListeners();
      return _sendingMessageStatus;
    }
  }
}
