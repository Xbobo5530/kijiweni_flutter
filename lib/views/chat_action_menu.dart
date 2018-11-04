import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_bubblt_action_item.dart';

class ChatActionMenuView extends StatelessWidget {
  final Color color;

  ChatActionMenuView({this.color});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: color,
        ),
        itemBuilder: (_) {
          return <PopupMenuItem<Widget>>[
            PopupMenuItem(
                child: ChatBubbleActionItemView(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
//              onTap: () {},
              color: Colors.red,
              label: likeText,
            )),
            PopupMenuItem(
              child: ChatBubbleActionItemView(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
//                onTap: () {},
                color: Colors.orange,
                label: shareText,
              ),
            ),
            PopupMenuItem(
              child: ChatBubbleActionItemView(
                icon: Icon(
                  Icons.reply,
                  color: Colors.white,
                ),
//                onTap: () {},
                color: Colors.blue,
                label: replyText,
              ),
            )
          ];
        });
  }
}
