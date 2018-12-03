import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/pages/community_page.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';

class JoinedCommunityListItemView extends StatelessWidget {
  final Community community;

  const JoinedCommunityListItemView({Key key, this.community}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: community.imageUrl != null
          ? CircleAvatar(
            radius: 24,
              backgroundColor: Colors.lightGreen,
              backgroundImage: NetworkImage(community.imageUrl),
            )
          : CircularButton(
              size: 48.0,
              elevation: 0.0,
              icon: Icon(
                Icons.people,
                color: primaryColor,
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
