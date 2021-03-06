import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/views/communities_item_view.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class ExploreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build at xplore is called');
    return Scaffold(
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return StreamBuilder(
            stream: model.communitiesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: MyProgressIndicator(),
                );
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot communityDoc =
                      snapshot.data.documents[index];
                  final Community community =
                      Community.fromSnapShot(communityDoc);

                  return CommunitiesItemView(community: community);
                },
              );
            },
          );
        },
      ),
    );
  }
}
