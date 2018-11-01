import 'package:kijiweni_flutter/models/chats_model.dart';
import 'package:kijiweni_flutter/models/login_model.dart';
import 'package:kijiweni_flutter/models/nav_model.dart';
import 'package:kijiweni_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with LoginModel, UserModel, NavModel, CommunitiesModel {
  MainModel() {
    checkLoginStatus();
    checkCurrentUser();
  }
}
