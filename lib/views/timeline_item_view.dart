import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';

const currentUserId = '002';

class ChatViewItem extends StatelessWidget {
  final Chat chat;
  ChatViewItem(this.chat);

  @override
  Widget build(BuildContext context) {
    var isMe;
    currentUserId == chat.createdBy ? isMe = true : isMe = false;
    final background = isMe ? Colors.blueGrey : Colors.greenAccent;
    final textColor = isMe ? Colors.white : Colors.black;
    final radius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );

    return currentUserId == chat.createdBy
        ? _buildSentMessageVIew(radius, background, textColor)
        : _buildReceivedMessageVIew(radius, background, textColor);
  }

  Container _buildSentMessageVIew(
      BorderRadius radius, Color bg, Color textColor) {
    var chatImageSection = _buildChatImageSection();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    chatImageSection,
                    Container(
                      constraints: BoxConstraints(maxWidth: 250.0),
                      child: new Text(
                        chat.message,
                        softWrap: true,
                        style: new TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: radius,
                color: bg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildReceivedMessageVIew(
      BorderRadius radius, Color bg, Color textColor) {
    var usernameSection = chat.username != null
        ? new Text(
            chat.username,
            style: new TextStyle(fontWeight: FontWeight.bold),
          )
        : new Container();
    var chatImageSection = _buildChatImageSection();
    var messageSection = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: chat.message != null
          ? new Text(
              chat.message,
              style: new TextStyle(color: textColor),
            )
          : new Container(),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new CircleAvatar(
            backgroundImage: NetworkImage(chat.userImageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: bg,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    usernameSection,
                    chatImageSection,
                    messageSection,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildChatImageSection() {
    var _hasChatImage;
    chat.chatImageUrl != null ? _hasChatImage = true : _hasChatImage = false;
    var chatImageSection = _hasChatImage
        ? Container(
            height: 250.0,
            width: 250.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                )),
                child: new Image.network(
                  chat.chatImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : new Container();
    return chatImageSection;
  }
}
