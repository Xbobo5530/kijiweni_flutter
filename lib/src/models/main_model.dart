import 'package:kijiweni_flutter/src/models/account_model.dart';
import 'package:kijiweni_flutter/src/models/chat_model.dart';
import 'package:kijiweni_flutter/src/models/community_model.dart';
import 'package:kijiweni_flutter/src/models/file_model.dart';
import 'package:kijiweni_flutter/src/models/joined_community_model.dart';
import 'package:kijiweni_flutter/src/models/nav_model.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with
        AccountModel,
        NavModel,
        CommunityModel,
        JoinedCommunityModel,
        ChatModel,
        FileModel
         {
  MainModel() {
    // _startup();
    // updateLoginStatus();
    firebaseCloudMessagingListeners();
    initUniLinks();
    _getJoinedCommunities();
  }

  _getJoinedCommunities()async{
    await updateLoginStatus(); if (isLoggedIn)updatedJoinedCommunities(currentUser);
  }

  

}
