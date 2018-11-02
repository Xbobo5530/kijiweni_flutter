import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class User {
  String username, userId, userImageUrl;
  int createdAt;

  User({@required this.username,
    this.userImageUrl,
    @required this.userId,
    this.createdAt})
      : assert(username != null);

  User.fromSnapshot(var value)
      : username = value[NAME_FIELD],
        userId = value[ID_FIELD],
        userImageUrl = value[IMAGE_URL_FIELD],
        createdAt = value[CREATED_AT_FIELD];
}
