class Chat {
  String message,
      chatImageUrl,
      chatThumbUrl,
      chatId,
      username,
      userId,
      userImageUrl,
      replyingTo;
  int imageStatus, createdAt;

  Chat(this.message, this.chatImageUrl, this.chatThumbUrl, this.chatId,
      this.username, this.userId, this.userImageUrl, this.replyingTo);

  Chat.fromSnapshot(var value) {
    this.message = value['message'];
    this.chatImageUrl = value['chat_image_url'];
    this.chatThumbUrl = value['chat_thumb_url'];
    this.chatId = value['chat_id'];
    this.username = value['username'];
    this.userId = value['user_id'];
    this.userImageUrl = value['user_image_url'];
    this.replyingTo = value['reply_source_id'];
    this.imageStatus = value['image_status'];
//    this.createdAt = value['created_at'];
  }
}
