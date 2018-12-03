import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/joined_community.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'JoinedCommunityModel:';

abstract class JoinedCommunityModel extends Model {
  Firestore _database = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StatusCode _joiningCommunityStatus;
  StatusCode get joiningCommunityStatus => _joiningCommunityStatus;
  Map<String, Community> _joinedCommunities;
  Map<String, Community> get joinedCommunities => _joinedCommunities;
  List<Community> _cachedJoinedCommunities;
  List<Community> get cachedJoinedCommunities => _cachedJoinedCommunities;

  // Stream<QuerySnapshot> joinedCommunitiesStream(User user) => _database
  //     .collection(USERS_COLLECTION)
  //     .document(user.id)
  //     .collection(COMMUNITIES_COLLECTION)
  //     .snapshots();

  Future<List<JoinedCommunity>> _updateJoinedCommunities(User user) async {
    bool _hasError = false;
    QuerySnapshot snapshot = await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(COMMUNITIES_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('error on getting joined communities');
      _hasError = true;
    });
    if (_hasError) {
      _joinedCommunities = Map();
      notifyListeners();
      return <JoinedCommunity>[];
    }

    List<DocumentSnapshot> documents = snapshot.documents;
    List<JoinedCommunity> tempJoinedCommunities = [];
    documents.forEach((document) {
      JoinedCommunity community = JoinedCommunity.fromSnapshot(document);
      tempJoinedCommunities.add(community);
    });

    return tempJoinedCommunities;
  }

  Future<Community> _getCommunityFromId(String id) async {
    bool _hasError = false;
    DocumentSnapshot document = await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(id)
        .get()
        .catchError((error) {
      print('error on getting community from id: $error');
      _hasError = true;
    });
    if (_hasError || !document.exists) return null;
    return Community.fromSnapShot(document);
  }

  /// sorts coommunities based on the ones with the most recent messages
  /// the [user] is the [User] that has joined these communities
  Future<List<Community>> sortedCommunities(User user) async {
    List<JoinedCommunity> joinedCommunities =
        await _updateJoinedCommunities(user);
        // print('joinedCommunities: $joinedCommunities');
    List<Community> tempSortedCommunities = [];

    joinedCommunities.forEach((joinedCommunity) async {
      Community community = await _getCommunityFromId(joinedCommunity.id);
      if (community != null) tempSortedCommunities.add(community);
    });
    tempSortedCommunities.sort((firstCommunity, secCommunity) =>
        secCommunity.lastMessageAt.compareTo(firstCommunity.lastMessageAt));
    tempSortedCommunities.forEach((community) {
      _joinedCommunities.putIfAbsent(community.id, () => community);
    });
    _cachedJoinedCommunities = tempSortedCommunities;
    notifyListeners();
    return tempSortedCommunities;
  }

  DocumentReference _getCommunityRef(Community community) {
    return _database.collection(COMMUNITIES_COLLECTION).document(community.id);
  }

  Future<StatusCode> joinCommunity(Community community, User user) async {
    print('$_tag at _createMembersRef');
    _joiningCommunityStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    Map<String, dynamic> memberMap = {
      MEMBER_ID_FIELD: user.id,
      COMMUNITY_ID_FIELD: community.id,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };
    await _getCommunityRef(community)
        .collection(MEMBERS_COLLECTION)
        .document(user.id)
        .setData(memberMap)
        .catchError((error) {
      print('$_tag error on joining community: $error');
      _hasError = true;
    });

    if (_hasError) {
      _joiningCommunityStatus = StatusCode.failed;
      notifyListeners();
      await sortedCommunities(user);
      return _joiningCommunityStatus;
    }

    _firebaseMessaging.subscribeToTopic(community.id);
    print('$_tag subscripbed to community ${community.name}');
    return await _addCommunityMemberRef(memberMap);
  }

  Future<StatusCode> _addCommunityMemberRef(
      Map<String, dynamic> memberMap) async {
    print('$_tag at _addCommunityMemberRef');
    bool _hasError = false;
    await _database
        .collection(USERS_COLLECTION)
        .document(memberMap[MEMBER_ID_FIELD])
        .collection(COMMUNITIES_COLLECTION)
        .document(memberMap[COMMUNITY_ID_FIELD])
        .setData(memberMap)
        .catchError((error) {
      print('$_tag error on adding community member ref: $error');
      _hasError = true;
    });
    if (_hasError) {
      _joiningCommunityStatus = StatusCode.failed;
      notifyListeners();
      leaveCommunity(memberMap[COMMUNITY_ID_FIELD], memberMap[MEMBER_ID_FIELD]);
      return _joiningCommunityStatus;
    }
    _joiningCommunityStatus = StatusCode.success;
    // updateJoinedCommunities(await _userFromId(memberMap[MEMBER_ID_FIELD]));
    return StatusCode.success;
  }

  Future<StatusCode> leaveCommunity(Community community, User user) async {
    print('$_tag at leaveCommunity');
    bool _hasError = false;
    await _getCommunityRef(community)
        .collection(MEMBERS_COLLECTION)
        .document(user.id)
        .delete()
        .catchError((error) {
      print('$_tag error on deleting user from community member list');
      _hasError = true;
    });

    if (_hasError) {
      return StatusCode.failed;
    }
    _firebaseMessaging.unsubscribeFromTopic(community.id);
    print('$_tag usubscripbed to community ${community.name}');
    return await _deleteCommunityRefFromUser(community, user);
  }

  Future<StatusCode> _deleteCommunityRefFromUser(
      Community community, User user) async {
    print('$_tag at _deleteCommunityRefFromUser');
    bool _hasError = false;
    await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(COMMUNITIES_COLLECTION)
        .document(community.id)
        .delete()
        .catchError((error) {
      print('$_tag error deleting community from user collections');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    // updateJoinedCommunities(user);
    notifyListeners();
    sortedCommunities(user);
    return StatusCode.success;
  }
}
