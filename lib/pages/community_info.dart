import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/member_count.dart';

class CommunityInfoPage extends StatelessWidget {
  final Community community;

  CommunityInfoPage({this.community});

  @override
  Widget build(BuildContext context) {
    final _imageSection = Container(
      width: 120.0,
      height: 120.0,
      child: Material(
        elevation: 4.0,
        shape: CircleBorder(),
        color: Colors.lightGreen,
        child: community.imageUrl != null
            ? CircleAvatar(
                backgroundColor: Colors.lightGreen,
                backgroundImage: NetworkImage(community.imageUrl),
              )
            : Icon(Icons.people, size: 50.0),
      ),
    );

    final _titleSection = ListTile(
      title: Text(
        community.name,
        textAlign: TextAlign.center,
      ),
      subtitle: community.description != null
          ? Text(
              community.description,
              textAlign: TextAlign.center,
            )
          : Container(),
    );

    final _membersSection = ExpansionTile(
      children: <Widget>[
        ListView.builder(itemBuilder: (context, index) {
          return ListTile();
        })
      ],
      title: Text(membersText),
      leading: CommunityMembersCountView(
          key: Key(community.id), community: community),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(community.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              _imageSection,
              _titleSection,
              _membersSection,
            ],
          ),
        ),
      ),
    );
  }
}
