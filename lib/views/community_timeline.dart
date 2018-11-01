import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/views/timeline_item_view.dart';

class CommunityTimelineView extends StatefulWidget {
  @override
  _CommunityTimelineViewState createState() => _CommunityTimelineViewState();
}

class _CommunityTimelineViewState extends State<CommunityTimelineView> {
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
