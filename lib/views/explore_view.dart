import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/communities_item_view.dart';
import 'package:scoped_model/scoped_model.dart';

class ExploreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return StreamBuilder(
            stream: model.communitiesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    final Community community =
                    Community.fromSnapShot(snapshot.data.documents[index]);
                    return CommunitiesItemView(community: community);
                  });
            },
          );
        },
      ),
    );
  }
}
