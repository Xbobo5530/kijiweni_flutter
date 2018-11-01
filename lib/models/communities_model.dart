import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CommunitiesModel:';

abstract class CommunitiesModel extends Model {
  final CollectionReference _communitiesCollection =
      Firestore.instance.collection(COMMUNITIES_COLLECTION);
  Firestore _database = Firestore.instance;

  Stream<dynamic> get communitiesStream => _communitiesCollection.snapshots();

  StatusCode _createCommunityStatus;

  StatusCode get createCommunityStatus => _createCommunityStatus;

  Stream<dynamic> getSubscribedCommunitiesStream(String userId) {
    return _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(COMMUNITIES_COLLECTION)
        .snapshots();
  }

  Future<Community> getCommunityFromId(String communityId) async {
    //todo handle community for mid
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
      return Community();
    }
    notifyListeners();
    return Community.fromSnapShot(communityDoc);
  }

  Future<void> createCommunity(Community community) async {
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
        CREATED_AT_FIELD, () =>
    DateTime
        .now()
        .millisecondsSinceEpoch);

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
  }

  Future<StatusCode> _createUserCommunityRef(String communityId,
      String userId) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: communityId,
      CREATED_AT_FIELD: DateTime
          .now()
          .millisecondsSinceEpoch
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
      return await _createSubScribedCommunityRef(communityId, userId);
  }

  Future<StatusCode> _createSubScribedCommunityRef(String communityId,
      String userId) async {
    print('$_tag at _createUserCommunityRef');
    bool _hasError = false;
    Map<String, dynamic> myCommunityMapRef = {
      ID_FIELD: communityId,
      CREATED_AT_FIELD: DateTime
          .now()
          .millisecondsSinceEpoch
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
      return StatusCode.success;
  }
}
