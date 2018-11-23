import 'package:kijiweni_flutter/models/account_model.dart';
import 'package:kijiweni_flutter/models/chat_model.dart';
import 'package:kijiweni_flutter/models/communities_model.dart';
import 'package:kijiweni_flutter/models/file_model.dart';

// import 'package:kijiweni_flutter/models/login_model.dart';
import 'package:kijiweni_flutter/models/nav_model.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';

import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with /*LoginModel*/ AccountModel,
        NavModel,
        CommunitiesModel,
        ChatModel,
        FileModel {
  MainModel() {
    _startup();
    firebaseCloudMessagingListeners();
    // checkLoginStatus();
//    checkCurrentUser();
    // updateJoinedCommunities(currentUser);
  }

  _startup() async {
    StatusCode updatingLoginSatus = await updateLoginStatus();
    if (updatingLoginSatus == StatusCode.success ||
        updatingLoginSatus == StatusCode.failed)
      await updateJoinedCommunities(currentUser);
  }
}
