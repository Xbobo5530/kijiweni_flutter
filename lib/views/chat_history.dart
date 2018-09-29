import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/values/strings.dart';
import 'package:kijiweni_flutter/views/chat_item_view.dart';

class ChatHistoryView extends StatefulWidget {
  @override
  _ChatHistoryViewState createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  @override
  Widget build(BuildContext context) {
    //todo get the chat list
    return StreamBuilder(
        stream: Firestore.instance.collection(CHATS_COLLECTION).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                var documents = snapshot.data.documents;
                Chat chat = Chat.fromSnapshot(documents[index]);
                return new ChatViewItem(chat);
              });
        });
  }
}
