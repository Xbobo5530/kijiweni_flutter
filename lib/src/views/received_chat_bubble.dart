import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/chat.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';

import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/views/chat_action_menu.dart';
import 'package:kijiweni_flutter/src/views/message_meta_section.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class ReceivedChatBubbleView extends StatelessWidget {
  final Chat chat;
  ReceivedChatBubbleView({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildMessageContent() {
      if (chat.fileType == null) return Container();
      if (chat.message != null &&
          chat.message.isNotEmpty &&
          chat.fileType == FILE_TYPE_NO_FILE)
        return Text(
          chat.message,
          style: TextStyle(fontSize: 18.0),
          softWrap: true,
        );
      if (chat.fileType != FILE_TYPE_NO_FILE && chat.message == null ||
          chat.message.isEmpty)
        return chat.fileUrl != null
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
              );

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: chat.fileUrl != null
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
                    ),
            ),
            Text(
              chat.message,
              style: TextStyle(fontSize: 18.0),
              softWrap: true,
            )
          ]);
    }

    final _userImageSection =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return FutureBuilder(
        future: model.userFromId(chat.createdBy),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.all(28.0),
              child: MyProgressIndicator(
                color: Colors.grey,
                size: 15.0,
              ),
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
                              color: Colors.grey, ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );

    final _messageSection = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          constraints: BoxConstraints(
              maxWidth: // 300.0
                  MediaQuery.of(context).size.width - 120),
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
            color: Colors.orange,
            borderRadius: BorderRadius.only(
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _userImageSection,
          SizedBox(width: 8.0,),
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
          ),
        ],
      ),
    );
  }
}
