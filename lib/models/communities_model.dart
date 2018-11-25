import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/user.dart';

import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

const _tag = 'CommunitiesModel:';

abstract class CommunitiesModel extends Model {
  final CollectionReference _communitiesCollection =
      Firestore.instance.collection(COMMUNITIES_COLLECTION);
  Firestore _database = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Map<String, User> _cachedUsers = Map();
  StatusCode _createCommunityStatus;
  StatusCode get createCommunityStatus => _createCommunityStatus;
  StatusCode _joiningCommunityStatus;
  StatusCode get joiningCommunityStatus => _joiningCommunityStatus;
  Map<String, Community> _joinedCommunities = Map();
  Map<String, Community> get joinedCommunities => _joinedCommunities;
  List<Community> _myCommunities = <Community>[];
  List<Community> get myCommunities => _myCommunities;

  Stream<dynamic> get communitiesStream => _communitiesCollection
      .orderBy(CREATED_AT_FIELD, descending: true)
      .snapshots();

  Future<Community> communityFromId(String communityId) async {
    bool _hasError = false;

    final DocumentSnapshot communityDoc = await _communitiesCollection
        .document(communityId)
        .get()
        .catchError((error) {
      print('$_tag error on fetching communy from Id: $error');
      _hasError = true;
    });
    if (_hasError || !communityDoc.exists) {
      // notifyListeners();
      // return Community(createdBy: null, createdAt: null, name: null);
      throw NullThrownError;
    }
    // notifyListeners();
    return Community.fromSnapShot(communityDoc);
  }

  Future<StatusCode> createCommunity(Community community, User user) async {
    print('$_tag at createCommunity');
    _createCommunityStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    Map<String, dynamic> _communityMap = Map();
    if (community.name != null)
      _communityMap.putIfAbsent(NAME_FIELD, () => community.name);
    if (community.description != null)
      _communityMap.putIfAbsent(DESC_FIELD, () => community.description);
    if (community.imageUrl != null)
      _communityMap.putIfAbsent(FILE_URL_FIELD, () => community.imageUrl);
    if (community.createdBy != null)
      _communityMap.putIfAbsent(CREATED_BY_FIELD, () => community.createdBy);
    _communityMap.putIfAbsent(
        CREATED_AT_FIELD, () => DateTime.now().millisecondsSinceEpoch);

    /// create a new community document on communities collection
    DocumentReference newCommunityDocRef =
        await _communitiesCollection.add(_communityMap).catchError((error) {
      print('$_tag error on creating community doc: $error');
      _hasError = true;
      _createCommunityStatus = StatusCode.failed;
      notifyListeners();
    });

    final communityId = newCommunityDocRef.documentID;
    community.id = communityId;

    if (_hasError) {
      _createCommunityStatus = StatusCode.failed;
      notifyListeners();
    } else {
      _createCommunityStatus = await _createUserCommunityRef(community, user);
      notifyListeners();
    }
    getUserCommunitiesFor(user);
    return _createCommunityStatus;
  }

  Future<StatusCode> _createUserCommunityRef(
      Community community, User user) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: community.id,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(MY_COMMUNITIES_COLLECTION)
        .document(community.id)
        .setData(myCommunityMapRef)
        .catchError((error) {
      print('$_tag error on creating a my collections refference');
      _hasError = true;
      _createCommunityStatus = StatusCode.failed;
      notifyListeners();
    });

    if (_hasError)
      return StatusCode.failed;
    else
      return await _createJoinedCommunityRef(community, user);
  }

  Future<StatusCode> _createJoinedCommunityRef(
      Community community, User user) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: community.id,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(COMMUNITIES_COLLECTION)
        .document(community.id)
        .setData(myCommunityMapRef)
        .catchError((error) {
      print('$_tag error on creating a my collections refference');
      _hasError = true;
      _createCommunityStatus = StatusCode.failed;
      notifyListeners();
    });

    if (_hasError)
      return StatusCode.failed;
    else
      return await joinCommunity(community, user);
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
    updateJoinedCommunities(await _userFromId(memberMap[MEMBER_ID_FIELD]));
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
    updateJoinedCommunities(user);
    notifyListeners();
    return StatusCode.success;
  }

  Future<StatusCode> updateJoinedCommunities(User user) async {
    print('$_tag at updateJoinedCommunities');
    if (user == null) {
      _joinedCommunities = Map();
      notifyListeners();
      return StatusCode.success;
    }
    bool _hasError = false;

    final QuerySnapshot snapshot = await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(COMMUNITIES_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting user collections: $error');
      _hasError = true;
    });

    if (_hasError) {
      _joinedCommunities = Map();
      notifyListeners();
      return StatusCode.failed;
    }
    final documents = snapshot.documents;
    Map<String, Community> _tempMap = Map();
    documents.forEach((document) async {
      Community community = await communityFromId(document.documentID);
      _tempMap.putIfAbsent(document.documentID, () => community);
    });
    _joinedCommunities = _tempMap;
    print(
        '$_tag updted _joinedCommunities has ${_joinedCommunities.length} communities');

    notifyListeners();
    return StatusCode.success;
  }

  resetJoinCommunityStatus() {
    _joiningCommunityStatus = null;
    notifyListeners();
  }

  Future<List<User>> getCommunityMembersFor(Community community) async {
    print('$_tag at getMembersCountFor');
    bool _hasError = false;
    final snapshot = await _getCommunityRef(community)
        .collection(MEMBERS_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting members  for community: $error');
      _hasError = true;
    });
    if (_hasError) return null;

    final documents = snapshot.documents;
    List<User> members = [];
    documents.forEach((document) async {
      final User user = await _userFromId(document.documentID);
      members.add(user);
    });
    return members;
  }

  Future<User> _userFromId(String userId) async {
    // print('$_tag at userFromId');
    bool _hasError = false;
    if (_cachedUsers[userId] != null) return _cachedUsers[userId];
    DocumentSnapshot document = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$_tag error on getting user document form id');
      _hasError = true;
    });
    if (_hasError) return null;
    final userFromId = User.fromSnapshot(document);
    _cachedUsers.putIfAbsent(userId, () => userFromId);
    return userFromId;
  }

  Future<void> getUserCommunitiesFor(User user) async {
    print('$_tag at getUserCommunitiesFor');
    if (user == null) return null;
    bool _hasError = false;
    final snapshot = await _database
        .collection(USERS_COLLECTION)
        .document(user.id)
        .collection(MY_COMMUNITIES_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting communities for user: $error');
      _hasError = true;
    });
    if (_hasError) return null;

    final documents = snapshot.documents;
    List<Community> communities = [];
    documents.forEach((document) async {
      Community community = await communityFromId(document.documentID);
      communities.add(community);
    });
    _myCommunities = communities;
    notifyListeners();
    // return communities;
  }

  List<Community> getJoinedCommuityList() {
    print('$_tag at getJoinedCommuityList');
    List<Community> communityList = <Community>[];
    _joinedCommunities.forEach((id, community) {
      communityList.add(community);
    });
    return communityList;
  }

  shareCommunity(Community community, User user) {
    Share.share(
        '${user.name} has invited you to join the ${community.name} community on Kijiweni.\n$APP_DEEP_LINK_HEAD${community.id}');
  }

  DocumentReference _getCommunityRef(Community community) {
    return _database.collection(COMMUNITIES_COLLECTION).document(community.id);
  }

  Future<StatusCode> deleteCommunity(Community community, User user) async {
    print('$_tag deleteCommunity');
    bool _hasError = false;
    await _getCommunityRef(community).delete().catchError((error) {
      print('$_tag error on deleting community');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return await _deleteCommunityRefFromUser(community, user);
  }
}
