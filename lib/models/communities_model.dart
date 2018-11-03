import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CommunitiesModel:';

//todo set a global _hasError variable to handle all error;
abstract class CommunitiesModel extends Model {
  final CollectionReference _communitiesCollection =
      Firestore.instance.collection(COMMUNITIES_COLLECTION);
  Firestore _database = Firestore.instance;

  Stream<dynamic> get communitiesStream => _communitiesCollection.snapshots();

  StatusCode _createCommunityStatus;
  StatusCode get createCommunityStatus => _createCommunityStatus;

  StatusCode _joiningCommunityStatus;

  StatusCode get joiningCommunityStatus => _joiningCommunityStatus;

  List<String> _joinedCommunities = <String>[];

  List<String> get joinedCommunities => _joinedCommunities;

  Stream<dynamic> getSubscribedCommunitiesStream(String userId) {
    return _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(COMMUNITIES_COLLECTION)
        .snapshots();
  }

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
      notifyListeners();
      return Community(createdBy: null, createdAt: null, name: null);
    }
    notifyListeners();
    return Community.fromSnapShot(communityDoc);
  }

  Future<StatusCode> createCommunity(Community community) async {
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
      _communityMap.putIfAbsent(IMAGE_URL_FIELD, () => community.imageUrl);
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

    if (_hasError) {
      _createCommunityStatus = StatusCode.failed;
      notifyListeners();
    } else {
      _createCommunityStatus =
          await _createUserCommunityRef(communityId, community.createdBy);
      notifyListeners();
    }
    return _createCommunityStatus;
  }

  Future<StatusCode> _createUserCommunityRef(
      String communityId, String userId) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: communityId,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(MY_COMMUNITIES_COLLECTION)
        .document(communityId)
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
      return await _createJoinedCommunityRef(communityId, userId);
  }

  Future<StatusCode> _createJoinedCommunityRef(
      String communityId, String userId) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: communityId,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };
    await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(COMMUNITIES_COLLECTION)
        .document(communityId)
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
      return await joinCommunity(communityId, userId);
  }

  Future<StatusCode> joinCommunity(String communityId, String userId) async {
    print('$_tag at _createMembersRef');
    _joiningCommunityStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    Map<String, dynamic> memberMap = {
      MEMBER_ID_FIELD: userId,
      COMMUNITY_ID_FIELD: communityId,
      CREATED_AT_FIELD: DateTime
          .now()
          .millisecondsSinceEpoch
    };
    await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(communityId)
        .collection(MEMBERS_COLLECTION)
        .document(userId)
        .setData(memberMap)
        .catchError((error) {
      print('$_tag error on joining community: $error');
      _hasError = true;
    });

    if (_hasError) {
      _joiningCommunityStatus = StatusCode.failed;
      notifyListeners();
      return _joiningCommunityStatus;
    } else {
      _joiningCommunityStatus = StatusCode.success;
      notifyListeners();
      return await _addCommunityMemberRef(memberMap);
    }
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

    updateJoinedCommunities(memberMap[MEMBER_ID_FIELD]);
    return StatusCode.success;
  }

  Future<StatusCode> leaveCommunity(String communityId, String userId) async {
    print('$_tag at leaveCommunity');
    bool _hasError = false;
    await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(communityId)
        .collection(MEMBERS_COLLECTION)
        .document(userId)
        .delete()
        .catchError((error) {
      print('$_tag error on deleting user from community member list');
      _hasError = true;
    });

    if (_hasError) {
      return StatusCode.failed;
    } else
      return await _deleteCommunityRefFromUser(communityId, userId);
  }

  Future<StatusCode> _deleteCommunityRefFromUser(String communityId,
      String userId) async {
    print('$_tag at _deleteCommunityRefFromUser');
    bool _hasError = false;
    await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(COMMUNITIES_COLLECTION)
        .document(communityId)
        .delete()
        .catchError((error) {
      print('$_tag error deleting community from user collections');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    updateJoinedCommunities(userId);
    notifyListeners();
    return StatusCode.success;
  }

  Future<StatusCode> updateJoinedCommunities(String userId) async {
    print('$_tag at updateJoinedCommunities');
    bool _hasError = false;

    final QuerySnapshot snapshot = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(COMMUNITIES_COLLECTION)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting user collections: $error');
      _hasError = true;
    });

    if (!_hasError) {
      final documents = snapshot.documents;
      final _tempList = <String>[];
      documents.forEach((document) {
        _tempList.add(document.documentID);
      });
      _joinedCommunities = _tempList;
    }

    notifyListeners();
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  resetJoinCommunityStatus() {
    _joiningCommunityStatus = null;
    notifyListeners();
  }
}
