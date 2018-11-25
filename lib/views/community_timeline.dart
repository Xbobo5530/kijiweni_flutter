import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/chat_list_item.dart';
import 'package:kijiweni_flutter/views/empty_community_page.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
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
          //TODO: test this
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              // print(snapshot.connectionState);
              if (!snapshot.hasData)
                return Center(child: MyProgressIndicator());

              if (snapshot.data.documents.length == 0)
                return EmptyCommunityPage(community: community);

              if (snapshot.hasError)
                return EmptyCommunityPage(community: community);
              return ListView.builder(
                controller: model.scrollController,
                reverse: false,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot chatDoc =
                      snapshot.data.documents[index];
                  final Chat chat = Chat.fromSnapshot(chatDoc);

                  return ChatListItemView(chat: chat);
                },
              );
              break;
            case ConnectionState.waiting:
              // print(snapshot.connectionState);
              return Center(child: MyProgressIndicator());
              break;
            case ConnectionState.none:
              // print(snapshot.connectionState);
              return EmptyCommunityPage(community: community);
              break;
          }

          // if (!snapshot.hasData)
          //   return Center(child: CircularProgressIndicator());
          // if (snapshot.data.documents.length == 0)
          //   return EmptyCommunityPage(community: community);

          // return ListView.builder(
          //   controller: model.scrollController,
          //   reverse: false,
          //   shrinkWrap: true,
          //   itemCount: snapshot.data.documents.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final DocumentSnapshot chatDoc = snapshot.data.documents[index];
          //     final Chat chat = Chat.fromSnapshot(chatDoc);

          //     return ChatListItemView(chat: chat);
          //   },
          // );
        },
      );
    });
  }
}
