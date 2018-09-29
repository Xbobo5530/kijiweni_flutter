class User {
  String username, userId, userImageUrl;

  User(this.username, this.userImageUrl, this.userId);

  User.fromSnapshot(var value) {
    this.username = value['username'];
    this.userId = value['user_id'];
    this.userImageUrl = value['user_image_url'];
  }
}
