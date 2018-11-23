import 'package:kijiweni_flutter/models/account_model.dart';
import 'package:kijiweni_flutter/models/chat_model.dart';
import 'package:kijiweni_flutter/models/communities_model.dart';
import 'package:kijiweni_flutter/models/file_model.dart';

// import 'package:kijiweni_flutter/models/login_model.dart';
import 'package:kijiweni_flutter/models/nav_model.dart';

import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with /*LoginModel*/ AccountModel, NavModel, CommunitiesModel, ChatModel, FileModel {
  MainModel() {
    updateLoginStatus();
    // checkLoginStatus();
//    checkCurrentUser();
    updateJoinedCommunities(currentUser);
  }
}
