import 'package:kijiweni_flutter/utils/consts.dart';

class User {
  String username, userId, userImageUrl;

  User(this.username, this.userImageUrl, this.userId);

  User.fromSnapshot(var value) {
    this.username = value[NAME_FIELD];
    this.userId = value[ID_FIELD];
    this.userImageUrl = value[IMAGE_URL_FIELD];
  }
}
