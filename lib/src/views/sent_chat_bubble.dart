import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/chat.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/views/chat_action_menu.dart';
import 'package:kijiweni_flutter/src/views/message_meta_section.dart';

class SentChatBubbleView extends StatelessWidget {
  final Chat chat;

  SentChatBubbleView({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(chat.toString());
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
                    child: Icon(Icons.image, size: 100.0,color: Colors.black12,),
                  ),
                );

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: 
              chat.fileUrl != null
              ? Image.network(chat.fileUrl)
              : FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Icon(Icons.image, size: 100.0,color: Colors.black12,),
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

    final _messageSection = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          constraints: BoxConstraints(
              maxWidth: //300.0
                  MediaQuery.of(context).size.width - 80),
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
            color: Colors.lightGreen,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(10.0),
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
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ChatActionMenuView(
            color: sentMessageColor,
            chat: chat,
            key: Key(chat.id),
          ),
          _messageStack,
        ],
      ),
    );
  }
}
