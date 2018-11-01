import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';

class CommunitiesItemView extends StatelessWidget {
  final Community community;

  CommunitiesItemView({this.community});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: community.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(community.imageUrl),
            )
          : Icon(Icons.people),
      title: Text(community.name),
      subtitle: community.description != null
          ? Text(community.description)
          : Container(),
    );
  }
}
