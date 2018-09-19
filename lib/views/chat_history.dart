import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/mock_data/chat_messages.dart';
import 'package:kijiweni_flutter/views/chat_item_view.dart';

class ChatHistoryView extends StatefulWidget {
  @override
  _ChatHistoryViewState createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  @override
  Widget build(BuildContext context) {
    //todo get the chat list
    return ListView.builder(
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          var chat = messagesList[index];
          return new ChatViewItem(chat);
        });
  }
}
