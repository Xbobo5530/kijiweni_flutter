import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/views/chat_action_menu.dart';

class SentChatBubbleView extends StatelessWidget {
  final Chat chat;

  SentChatBubbleView({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _messageSection = Container(
        constraints: BoxConstraints(maxWidth: 300.0),
        child: Text(
          chat.message,
          style: TextStyle(fontSize: 18.0),
          softWrap: true,
        ),
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
        ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ChatActionMenuView(
          color: sentMessageColor,
          chat: chat,
          key: Key(chat.id),
        ),
        _messageSection,
      ],
    );
  }
}
