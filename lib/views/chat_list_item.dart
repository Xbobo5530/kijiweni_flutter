import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/chat_bubble.dart';
import 'package:kijiweni_flutter/views/empty_community_page.dart';
import 'package:kijiweni_flutter/views/received_chat_bubble.dart';
import 'package:kijiweni_flutter/views/sent_chat_bubble.dart';
import 'package:scoped_model/scoped_model.dart';

// const _tag = 'ChatListItemView:';

class ChatListItemView extends StatelessWidget {
  final Chat chat;

  ChatListItemView({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        if (model.currentUser == null) return EmptyCommunityPage();
        final bool isMe = chat.createdBy == model.currentUser.id;
//        print(
//            '$_tag chat was created by: ${chat.createdBy}\ncurrent user is: ${model.currentUser.id}');
        
        
        return ChatBubbleView(
          chat: chat,
          key:  Key(chat.id),
          isMe: isMe,
        );
        
        return isMe
            ? SentChatBubbleView(chat: chat)
            : ReceivedChatBubbleView(key: Key(chat.id), chat: chat);
      },
    );
  }
}
