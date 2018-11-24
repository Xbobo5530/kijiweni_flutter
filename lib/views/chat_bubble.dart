import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_action_menu.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/message_meta_section.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatBubbleView extends StatelessWidget {
  final bool isMe;
  final Chat chat;

  const ChatBubbleView({Key key, this.isMe, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageSection = chat.fileType == FILE_TYPE_IMAGE
        ? chat.fileUrl != null
            ? Image.network(chat.fileUrl)
            : FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(
                    Icons.image,
                    size: 100.0,
                    color: Colors.black12,
                  ),
                ),
              )
        : Container();

    final _messageTextSection = chat.message != null && chat.message.isNotEmpty
        ? Text(
            chat.message,
            style: TextStyle(fontSize: 18.0),
            softWrap: true,
          )
        : Container();

    _buildReplyContent(MainModel model, Chat chat) => ListTile(
          title: chat.createdBy == model.currentUser.id
              ? Text(
                  youText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : FutureBuilder<User>(
                  future: model.userFromId(chat.createdBy),
                  builder: (context, snapshot) => !snapshot.hasData
                      ? Container()
                      : Text(
                          snapshot.data.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
          subtitle: Text(chat.message != null && chat.message.isNotEmpty
              ? chat.message
              : chat.fileType == FILE_TYPE_IMAGE ? photoText : Container()),
        );

    final _replyingToView = Container(
      color: Colors.white70,
      child: ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => FutureBuilder<Chat>(
            future: model.chatFromId(chat.replyingTo, chat.communityId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();

              return _buildReplyContent(model, chat);
            }),
      ),
    );

    Widget _buildMessageContent() {
      if (chat.replyingTo != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _replyingToView,
            _imageSection,
            _messageTextSection,
          ],
        );
      }
      if (chat.fileType == null)
        return Container(); //TODO: remove on flush data
      if (chat.message != null &&
          chat.message.isNotEmpty &&
          chat.fileType == FILE_TYPE_NO_FILE) return _messageTextSection;
      if (chat.fileType != FILE_TYPE_NO_FILE && chat.message == null ||
          chat.message.isEmpty) return _imageSection;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: _imageSection,
            ),
            _messageTextSection
          ]);
    }

    final _messageSection = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          constraints: BoxConstraints(
              minWidth: 60.0,
              maxWidth: //300.0
                  isMe
                      ? MediaQuery.of(context).size.width - 80
                      : MediaQuery.of(context).size.width - 120),
          child: _buildMessageContent(),
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: isMe ? sentMessageColor : receivedMessageColor,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(5.0),
                  ),
          )),
    );

    final _messageStack = Stack(
      children: <Widget>[
        _messageSection,
        MessageMetaSectionView(chat: chat),
      ],
    );
    final _usernameSection = ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return FutureBuilder(
          future: model.userFromId(chat.createdBy),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final User _user = snapshot.data;
            return Container(
              padding: const EdgeInsets.only(left: 4.0),
              width: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _user != null
                      ? Text(
                          _user.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );

    final _actionMenu = ChatActionMenuView(
      color: isMe ? sentMessageColor : receivedMessageColor,
      chat: chat,
      key: Key(chat.id),
    );
    final _sentBubbleChildren = <Widget>[
      _actionMenu,
      _messageStack,
    ];

    final _userImageSection =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return FutureBuilder(
        future: model.userFromId(chat.createdBy),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.all(28.0),
              child: CircularButton(
                  size: 45.0, icon: Icon(Icons.person, size: 30.0)),
            );
          final _user = snapshot.data;
          return _user == null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 42.0,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.lightGreen,
                    backgroundImage: NetworkImage(
                      _user.imageUrl,
                    ),
                  ),
                );
        },
      );
    });
    final _receivedBubbleChilren = <Widget>[
      _userImageSection,
      SizedBox(
        width: 8.0,
      ),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _usernameSection,
                _messageStack,
              ],
            ),
            ChatActionMenuView(
              color: receivedMessageColor,
              chat: chat,
              key: Key(chat.id),
            )
          ],
        ),
      )
    ];

    return Padding(
      padding: isMe
          ? const EdgeInsets.only(right: 8.0)
          : const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: isMe ? _sentBubbleChildren : _receivedBubbleChilren,
      ),
    );
  }
}
