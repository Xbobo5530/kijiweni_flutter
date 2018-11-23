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
  StatusCode _handlingLikeMessageStatus;
  StatusCode get handlingLikeMessageStatus => _handlingLikeMessageStatus;
  bool _isReplying = false;
  bool get isReplying => _isReplying;
  String _replyingToId;
  String get replyingToId => _replyingToId;
  Chat _latestChat;
  Chat get latestChat => _latestChat;

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
    // if (chat.fileUrl != null)
    //   chatMap.putIfAbsent(CHAT_IMAGE_URL_FIELD, () => chat.fileUrl);
    chatMap.putIfAbsent(
        CREATED_AT_FIELD, () => chat.createdAt);
    
    chatMap.putIfAbsent(FILE_TYPE_FIELD, ()=>chat.fileType);

    DocumentReference docRef = await _database
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
      //updateListViewPosition();
      _latestChat = await _chatFromId(chat.communityId, docRef.documentID);
      notifyListeners();
      return _sendingMessageStatus;
    }
  }

  Future<Chat> _chatFromId(String communityId, String chatId)async{
    print('$_tag _chatFromId');
    bool _hasError = false;
    DocumentSnapshot document = await _database
    .collection(COMMUNITIES_COLLECTION)
    .document(communityId)
    .collection(CHATS_COLLECTION)
    .document(chatId)
    .get()
    .catchError((error){
      print('$_tag error on getting latest chat document: $error');
      _hasError = true;

    });
    if (_hasError || !document.exists) return null;
    return Chat.fromSnapshot(document);
    
  }

  Future<StatusCode> handleLikeMessage(Chat chat, String currentUserId) async {
    print('$_tag at likeMessage');
    _handlingLikeMessageStatus = StatusCode.waiting;
    notifyListeners();

    final _likeRef = _database
        .collection(COMMUNITIES_COLLECTION)
        .document(chat.communityId)
        .collection(CHATS_COLLECTION)
        .document(chat.id)
        .collection(LIKES_COLLECTION)
        .document(currentUserId);

    bool _hasError = false;

    //check if current user has liked chat
    final DocumentSnapshot likeDocument = await _likeRef.get().catchError((
        error) {
      print('$_tag error on checking if user has liked chat');
      _hasError = true;
    });
    if (!_hasError && likeDocument.exists) {
      _likeRef.delete().catchError((error) {
        print('$_tag error on deleting like document ref');
      });
      _handlingLikeMessageStatus = StatusCode.success;
      notifyListeners();
      return _handlingLikeMessageStatus;
    }

    Map<String, dynamic> likeMap = {
      CREATED_BY_FIELD: currentUserId,
      CREATED_AT_FIELD: DateTime
          .now()
          .millisecondsSinceEpoch,
    };

    await _likeRef
        .setData(likeMap)
        .catchError((error) {
      print('$_tag error on adding like');
      _hasError = true;
    });

    if (_hasError) {
      _handlingLikeMessageStatus = StatusCode.failed;
      notifyListeners();
      return _handlingLikeMessageStatus;
    }

    _handlingLikeMessageStatus = StatusCode.success;
    notifyListeners();
    return _handlingLikeMessageStatus;
  }


  replyMessage(Chat chat) {
    //todo handle reply message;
    _replyingToId = chat.id;
    _isReplying = true;
    notifyListeners();
  }

  cancelReplyMessage() {
    _isReplying = false;
    notifyListeners();
  }

  shareMessage(Chat chat) {
    //todo handle share message
  }

  Future<int> getChatLikesCountFor(Chat chat) async {
    // print('$_tag at getChatLikesCountFor');
    bool _hasError = false;
    final snapshot = await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(chat.communityId)
        .collection(CHATS_COLLECTION)
        .document(chat.id)
        .collection(LIKES_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting likes count for chat: $error');
      _hasError = true;
    });
    if (_hasError) return 0;
    // print('$_tag chat has ${snapshot.documents.length} likes');
    return snapshot.documents.length;
  }

  Future<bool> hasLikedChat
  (String userId Chat chat)async{
  // print('$_tag at hasLikedChat');
  bool _hasError = false;
  final document = await _database
      .collection(COMMUNITIES_COLLECTION)
      .document(chat.communityId)
      .collection(CHATS_COLLECTION)
      .document(chat.id)
      .collection(LIKES_COLLECTION)
      .document(userId). get ()
      .catchError((error) {
  print('$_tag error on getting current user like doc: $error');
  _hasError = true;
  });

  if(_hasError || !document.exists) return false;
  return true;
  }
}
