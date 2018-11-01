import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:meta/meta.dart';

class Community {
  String name, id, imageUrl, createdBy, description;
  int createdAt;

  Community(
      {@required this.name,
      this.description,
      this.id,
      this.imageUrl,
      @required this.createdAt,
      @required this.createdBy})
      : assert(name != null),
        assert(createdAt != null),
        assert(createdBy != null);

  Community.fromSnapShot(var value) {
    this.name = value[NAME_FIELD];
    this.description = value[DESC_FIELD];
    this.id = value[ID_FIELD];
    this.imageUrl = value[IMAGE_URL_FIELD];
    this.createdBy = value[CREATED_BY_FIELD];
    this.createdAt = value[CREATED_AT_FIELD];
  }
}
