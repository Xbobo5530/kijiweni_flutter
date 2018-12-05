import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/chat.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/views/chat_list_item.dart';
import 'package:kijiweni_flutter/src/views/empty_community_page.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityTimelineView extends StatelessWidget {
  final Community community;

  CommunityTimelineView({this.community});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return StreamBuilder<QuerySnapshot>(
        stream: model.communityChatStream(community),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Center(child: MyProgressIndicator());

          if (snapshot.data.documents.length == 0)
            return EmptyCommunityPage(community: community);

          if (snapshot.hasError)
            return EmptyCommunityPage(community: community);
          return ListView.builder(
            controller: model.scrollController,
            reverse: true,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot chatDoc = snapshot.data.documents[index];
              final Chat chat = Chat.fromSnapshot(chatDoc);

              // return ChatListItemView(chat: chat, key: Key(chat.id),);
              return FutureBuilder<Chat>(
                  initialData: chat,
                  future: model.refineChat(chat),
                  builder: (context, snapshot) {
                    // print(chat.replyToMessage);
                    return ChatListItemView(
                        chat: snapshot.data,
                        key: Key(snapshot.data.id),
                      );});
            },
          );
        },
      );
    });
  }
}
