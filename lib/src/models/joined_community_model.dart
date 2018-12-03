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
  StatusCode _userCommunityStatus;
  StatusCode get userCommunityStatus => _userCommunityStatus;
  Map<String, Community> _joinedCommunitiesMap = Map();
  Map<String, Community> get joinedCommunitiesMap => _joinedCommunitiesMap;
  List<Community> _cachedJoinedCommunities;
  List<Community> _tempSortedCommunities = [];
  List<Community> get cachedJoinedCommunities => _cachedJoinedCommunities;

  /// updates the joined communities by making getting the latest list of
  /// joined communities and returning a [Future<List<Community>>] that is
  /// a sorted list of [joinedCommunities] sorted based on the [lastMessageAt]
  /// variable for each community
  /// the [user] is the [User] that has joined these communities
  /// usually the [currentUser]
  Future<List<Community>> updatedJoinedCommunities(User user) async {
    List<JoinedCommunity> joinedCommunities =
        await _fetchJoinedCommunities(user);

    joinedCommunities.forEach((joinedCommunity) async {
      Community community = await _getCommunityFromId(joinedCommunity.id);
      if (community != null &&
          !joinedCommunitiesMap.containsKey(community.id) &&
          _isNotCached(community)) _tempSortedCommunities.add(community);
    });
    _tempSortedCommunities.sort((firstCommunity, secCommunity) =>
        secCommunity.lastMessageAt.compareTo(firstCommunity.lastMessageAt));
    _tempSortedCommunities.forEach((community) {
      _joinedCommunitiesMap.putIfAbsent(community.id, () => community);
    });

    _cachedJoinedCommunities = _tempSortedCommunities;
    return _cachedJoinedCommunities;
  }

  bool _isNotCached(Community community) {
    bool _isCached = true;
    _cachedJoinedCommunities.forEach((cCommunity) {
      if (cCommunity.id == community.id) _isCached = false;
    });
    return _isCached;
  }

  Future<List<JoinedCommunity>> _fetchJoinedCommunities(User user) async {
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
    Community community = Community.fromSnapShot(document);
    return community;
  }

  DocumentReference _getCommunityRef(Community community) {
    return _database.collection(COMMUNITIES_COLLECTION).document(community.id);
  }

  Future<StatusCode> joinCommunity(Community community, User user) async {
    print('$_tag at _createMembersRef');
    _userCommunityStatus = StatusCode.waiting;
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
      _userCommunityStatus = StatusCode.failed;
      notifyListeners();
      await updatedJoinedCommunities(user);

      _updateCache(community, Action.join);
      return _userCommunityStatus;
    }

    _firebaseMessaging.subscribeToTopic(community.id);
    print('$_tag subscripbed to community ${community.name}');
    _userCommunityStatus = await _addCommunityMemberRef(memberMap);
    await updatedJoinedCommunities(user);
    return _userCommunityStatus;
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
      _userCommunityStatus = StatusCode.failed;
      notifyListeners();
      leaveCommunity(memberMap[COMMUNITY_ID_FIELD], memberMap[MEMBER_ID_FIELD]);
      return _userCommunityStatus;
    }
    _userCommunityStatus = StatusCode.success;
    // updateJoinedCommunities(await _userFromId(memberMap[MEMBER_ID_FIELD]));

    notifyListeners();
    return _userCommunityStatus;
  }

  Future<StatusCode> leaveCommunity(Community community, User user) async {
    print('$_tag at leaveCommunity');
    _userCommunityStatus = StatusCode.waiting;
    notifyListeners();
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
      _userCommunityStatus = StatusCode.failed;
      notifyListeners();
      return _userCommunityStatus;
    }
    _firebaseMessaging.unsubscribeFromTopic(community.id);
    print('$_tag usubscripbed to community ${community.name}');
    _userCommunityStatus = await _deleteCommunityRefFromUser(community, user);
    notifyListeners();
    return _userCommunityStatus;
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
    _joinedCommunitiesMap.remove(community.id);
    _updateCache(community, Action.leave);
    notifyListeners();
    return StatusCode.success;
  }

  _updateCache(Community community, Action action) {
    switch (action) {
      case Action.leave:
        _cachedJoinedCommunities.remove(community);
        _joinedCommunitiesMap.remove(community.id);
        break;
      case Action.join:
        _cachedJoinedCommunities.add(community);
        _joinedCommunitiesMap.putIfAbsent(community.id, () => community);
        break;
      default:
        print('Action is: $action');
    }

    notifyListeners();
  }
}
