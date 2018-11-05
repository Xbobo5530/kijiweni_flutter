import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/chat_list_item.dart';
import 'package:kijiweni_flutter/views/empty_community_page.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityTimelineView extends StatelessWidget {
  final Community community;

  CommunityTimelineView({this.community});

  @override
  Widget build(BuildContext context) {
//    final _scrollController = ScrollController();

    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return StreamBuilder(
        stream: model.communityChatStream(community),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.documents.length == 0)
            return EmptyCommunityPage(community: community);

//            SchedulerBinding.instance.addPostFrameCallback((_) {
//
//            });

          return ListView.builder(
            controller: model.scrollController,
            reverse: false,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot chatDoc = snapshot.data.documents[index];
              final Chat chat = Chat.fromSnapshot(chatDoc);
              chat.id = chatDoc.documentID;

//              if (model.sendingMessageStatus == StatusCode.success)
//                _scrollController.animateTo(
//                  _scrollController.position.maxScrollExtent,
//                  duration: const Duration(milliseconds: 300),
//                  curve: Curves.easeOut,
//                );

              return ChatListItemView(chat: chat);
            },
          );
        },
      );
    });
  }
}
