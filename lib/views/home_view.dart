import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/community_page.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';

import 'package:kijiweni_flutter/views/empty_home_page.dart';
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
                (commuity) => JoinedCommunityListItem(community: commuity),
              )
              .toList());
    }));
  }
}

class JoinedCommunityListItem extends StatelessWidget {
  final Community community;

  const JoinedCommunityListItem({Key key, this.community}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: community.imageUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.lightGreen,
              backgroundImage: NetworkImage(community.imageUrl),
            )
          : CircularButton(
              size: 50.0,
              elevation: 0.0,
              icon: Icon(
                Icons.people,
              ),
            ),
      title: Text(community.name),
      subtitle:
          community.description != null ? Text(community.description) : null,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CommunityPage(community: community, key: Key(community.id)))),
    );
  }
}
