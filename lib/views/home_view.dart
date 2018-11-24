import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/empty_home_page.dart';
import 'package:kijiweni_flutter/views/joined_list_item.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // _buildCommunityTile(Community community) =>

    return Scaffold(body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      print('${model.joinedCommunities.length}');

      if (model.currentUser == null ||
          model.joinedCommunities == null ||
          model.joinedCommunities.length == 0) return EmptyHomePageView();

      return ListView(
          children: model
              .getJoinedCommuityList()
              .map(
                (community) => JoinedCommunityListItemView(
                    community: community, key: Key(community.id)),
              )
              .toList());
    }));
  }
}
