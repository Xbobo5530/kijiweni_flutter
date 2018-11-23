import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/community_page.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/communities_item_view.dart';
import 'package:kijiweni_flutter/views/empty_home_page.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          if (model.currentUser == null) return EmptyHomePageView();
          final userId = model.currentUser.id;
          return StreamBuilder(
            stream: model.getSubscribedCommunitiesStream(userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (snapshot.data.documents.length == 0)
                return EmptyHomePageView();

              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    final DocumentSnapshot communityDoc =
                        snapshot.data.documents[index];
                    final communityId = communityDoc.documentID;
                    return FutureBuilder(
                      future: model.communityFromId(communityId),
                      builder: (BuildContext context,
                          AsyncSnapshot<Community> snapshot) {
                        if (!snapshot.hasData) return Container();
                        final Community community = snapshot.data;

                        return ListTile(
                          leading: community.imageUrl != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.lightGreen,
                                  backgroundImage:
                                      NetworkImage(community.imageUrl),
                                )
                              : CircularButton(
                                  size: 50.0,
                                  elevation: 0.0,
                                  icon: Icon(
                                    Icons.people,
                                  ),
                                ),
                          title: Text(community.name),
                          subtitle: community.description != null
                              ? Text(community.description)
                              : null,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunityPage(
                                      community: community,
                                      key: Key(community.id)))),
                        );
                      },
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
