import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const _tag = 'ChatModel:';

abstract class ChatModel extends Model {
  Firestore _database = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StatusCode _sendingMessageStatus;
  StatusCode get sendingMessageStatus => _sendingMessageStatus;
  StatusCode _handlingLikeMessageStatus;
  StatusCode get handlingLikeMessageStatus => _handlingLikeMessageStatus;
  bool _isReplying = false;
  bool get isReplying => _isReplying;
  Chat _replyingTo;
  Chat get replyingTo => _replyingTo;
  Chat _latestChat;
  Chat get latestChat => _latestChat;
  Map<String, Chat> _cachedChats = Map();

  Stream<dynamic> communityChatStream(Community community) {
    return _database
        .collection(COMMUNITIES_COLLECTION)
        .document(community.id)
        .collection(CHATS_COLLECTION)
        .snapshots();
  }

  Future<StatusCode> sendMessage(Chat chat, User user, Community community) async {
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
      if (_isReplying && _replyingTo != null)
      chatMap.putIfAbsent(REPLYING_TO_FIELD, ()=>_replyingTo.id);
      cancelReplyMessage();
    // if (chat.fileUrl != null)
    //   chatMap.putIfAbsent(CHAT_IMAGE_URL_FIELD, () => chat.fileUrl);
    chatMap.putIfAbsent(
        CREATED_AT_FIELD, () => chat.createdAt);
    chatMap.putIfAbsent(FILE_TYPE_FIELD, ()=>chat.fileType);
    chatMap.putIfAbsent(REPORTS_FIELD, ()=>chat.reports);
    print(chat.toString());

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
      {_sendingMessageStatus = StatusCode.failed;
      notifyListeners();
      return _sendingMessageStatus;
      }
    
      _sendingMessageStatus = StatusCode.success;
      //updateListViewPosition();
      _latestChat = await _chatFromId(chat.communityId, docRef.documentID);
      notifyListeners();
      chat.id = docRef.documentID;
      _addToMessageForNotifications(chat, user, community);
      return _sendingMessageStatus;
    
  }

  Future<StatusCode> _addToMessageForNotifications(Chat chat, User user, Community community)async{
    print('$_tag at _addToMessageForNotifications');
    bool _hasError = false;
    final title = '${user.name} @ ${community.name}';
    final body = _creadeMessageBody(chat, user); 
    Map<String, dynamic> messageMap = {
      TITLE_FIELD : title,
      BODY_FIELD : body,
      COMMUNITY_ID_FIELD : chat.communityId,
      CHAT_ID_FIELD : chat.id,
      USER_ID_FIELD : chat.createdBy
    };
    await _database.collection(MESSAGES_COLLECTION).add(messageMap)
    .catchError((error){
      print('$_tag error on adding message to messages for notifs: $error');
      _hasError = true;

    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }
  String  _creadeMessageBody(Chat chat, User user){
    if (chat.fileType == FILE_TYPE_IMAGE) return '${user.name} has shared an image';
    if (chat.fileType == FILE_TYPE_VIDEO) return '${user.name} has shared a video';
    if (chat.message != null && chat.message.isNotEmpty) return chat.message;
    return 'You have a new message';
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
    _replyingTo = chat;
    _isReplying = true;
    notifyListeners();
  }

  cancelReplyMessage() {
    _isReplying = false;
    _replyingTo = null;
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
  
  void firebaseCloudMessagingListeners() {

    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      // print(token);
    });

    _firebaseMessaging.subscribeToTopic(SUBSCRIPTION_UPDATES);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true)
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings)
  //   {
  //     print("Settings registered: $settings");
  //   });
  // }

  /// Returns a [Future<Chat>] after taking in a [chatId] and a [communityId]
  /// Returns a [null] if an [error] occurs and prints the [error] to the log
  Future<Chat>chatFromId(String chatId, String communityId)async{
    print('$_tag at chatFromId');
    if (_cachedChats.containsKey(chatId)) return _cachedChats[chatId];
    bool _hasError = false;
    DocumentSnapshot document =await _database.collection(COMMUNITIES_COLLECTION)
      .document(communityId)
      .collection(CHATS_COLLECTION)
      .document(chatId)
      .get()
      .catchError((error){
        print('$_tag error on getting chat doc for caht from it: $error');
        _hasError = true;
      });
    if (_hasError || !document.exists) return null;
    Chat chat = Chat.fromSnapshot(document);
    _cachedChats.putIfAbsent(chatId, ()=>chat);
    return chat;
  }

  /// Returns the [DocumentReference] for a [chat]
   DocumentReference _chatReference(Chat chat) => _database.collection(COMMUNITIES_COLLECTION)
      .document(chat.communityId)
      .collection(CHATS_COLLECTION)
      .document(chat.id);

  /// Deletes the [chat]
  /// called the when [currentUser] deletes the [chat] 
  /// or when the chat has exceeded the [CHAT_REPORTS_LIMIT]
  /// returns a [StatusCode] for whether the deletion 
  /// was [StatusCode.success], or [StatusCode.failed]
  Future<StatusCode> deleteChat(Chat chat)async{
    print('$_tag at deleteChat');
    bool _hasError = false;
    _chatReference(chat).delete().catchError((error){
      print('$_tag error on deleting chat : $error');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  /// Returns a [DocumentReference] for the [user] in the
  /// [REPORTS_COLLECTION] in the [chat]
  DocumentReference _getReport(Chat chat, User user){
    return _database.collection(COMMUNITIES_COLLECTION).document(
      chat.communityId
    ).collection(CHATS_COLLECTION)
    .document(chat.id)
    .collection(REPORTS_COLLECTION)
    .document(user.id);
  }

  /// checks if the [user] has alredy submitted a report
  /// for the [chat]
  /// returns a [Future<bool>] which is [true] if the [user]
  /// has already submitted a report and [false] if the [user]
  /// has not submitted a report
  Future<bool> _userHasReported(User user, Chat chat)async{
    print('$_tag at _userHasReported');
    bool _hasError = false;
    DocumentSnapshot document = await _getReport(chat, user).get()
    .catchError((error){
      print('$_tag error on getting user report document: $error');
      _hasError = true;
    });
    if (_hasError) return false;
    return document.exists;
    
  }

  /// submits a report to a [chat]
  /// it also creates a reports document for the [user] 
  /// who has submitted a report and keeps track of how many 
  /// reports hace been submitted for the [chat]
  /// if the value [reports] of type [int] esceeds the [CHAT_REPORTS_LIMIT]
  /// the [chat] is automatcally deleted and [deleteChat(Chat)] is called
  /// if the [CHAT_REPORTS_LIMIT] is not reached, the [chat] [reports] value
  /// is increased by 1
  Future<StatusCode> reportChat(Chat chat, User user)async{
    print('$_tag at reportChat');
    if (chat.reports == CHAT_REPORTS_LIMIT) {
      deleteChat(chat);
      return StatusCode.success;
    }
    if (await _userHasReported(user, chat)) return StatusCode.success;

    bool _hasError = false;
    
    _database.runTransaction((transaction)async{
      DocumentSnapshot freshSnapshot = await transaction.get(
        _chatReference(chat)
      );

      await transaction.update(
           freshSnapshot.reference, {REPORTS_FIELD: freshSnapshot[REPORTS_FIELD] + 1}).catchError(
             (error){
               print('$_tag error on performing transaction for reports: $error');
               _hasError = true;
             }
           );
     });
     if (_hasError) return StatusCode.failed;
     return _addUserReport(chat, user);
  }

  /// creates a report document for a [user] in the [chat] document
  Future<StatusCode> _addUserReport(Chat chat, User user) async{
    print('$_tag at _addUserReport');
    bool _hasError = false;
    Map<String, dynamic> reportMap = {
      CREATED_AT_FIELD : DateTime.now().millisecondsSinceEpoch,
      CREATED_BY_FIELD : user.id,

    };
    await _getReport(chat, user).setData(reportMap)
    .catchError((error){
      print('$_tag errot on submitting report for user: $error')
    ;
    _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;

  }
}
