import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class User {
  String name, id, imageUrl;
  int createdAt;

  User({@required this.name, this.imageUrl, this.id, this.createdAt})
      : assert(name != null);

  User.fromSnapshot(var value)
      : name = value[NAME_FIELD],
        id = value[ID_FIELD],
        imageUrl = value[IMAGE_URL_FIELD],
        createdAt = value[CREATED_AT_FIELD];
}
