import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CommunitiesModel:';

abstract class CommunitiesModel extends Model {
  final CollectionReference _communitiesCollection =
      Firestore.instance.collection(COMMUNITIES_COLLECTION);
  Firestore _database = Firestore.instance;

  Stream<dynamic> get communitiesStream =>
      _database.collection(COMMUNITIES_COLLECTION).snapshots();

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
}
