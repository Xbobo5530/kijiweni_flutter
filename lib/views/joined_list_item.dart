import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/pages/community_page.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';

class JoinedCommunityListItemView extends StatelessWidget {
  final Community community;

  const JoinedCommunityListItemView({Key key, this.community}) : super(key: key);
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