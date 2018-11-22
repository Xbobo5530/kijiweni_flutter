import 'package:kijiweni_flutter/models/account_model.dart';
import 'package:kijiweni_flutter/models/chat_model.dart';
import 'package:kijiweni_flutter/models/communities_model.dart';
import 'package:kijiweni_flutter/models/image_model.dart';
// import 'package:kijiweni_flutter/models/login_model.dart';
import 'package:kijiweni_flutter/models/nav_model.dart';

import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with /*LoginModel*/ AccountModel, NavModel, CommunitiesModel, ChatModel, ImageModel {
  MainModel() {
    updateLoginStatus();
    // checkLoginStatus();
//    checkCurrentUser();
  //  if (isLoggedIn) updateJoinedCommunities(currentUser.id);
  }
}
