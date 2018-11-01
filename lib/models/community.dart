import 'package:kijiweni_flutter/utils/consts.dart';

class Community {
  String name, id, imageUrl, createdBy, description;
  int createdAt;

  Community(
      {this.name,
      this.description,
      this.id,
      this.imageUrl,
      this.createdAt,
      this.createdBy});

  Community.fromSnapShot(var value) {
    this.name = value[NAME_FIELD];
    this.description = value[DESC_FIELD];
    this.id = value[ID_FIELD];
    this.imageUrl = value[IMAGE_URL_FIELD];
    this.createdBy = value[CREATED_BY_FIELD];
    this.createdAt = value[CREATED_AT_FIELD];
  }
}
