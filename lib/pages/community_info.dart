import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/join_button.dart';
import 'package:kijiweni_flutter/views/member_count.dart';
import 'package:scoped_model/scoped_model.dart';

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

    final _joinButtonSection = Row(
      children: <Widget>[
        Expanded(
          child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return model.joinedCommunities.contains(community.id)
                  ? Container()
                  : JoinButtonView(communityId: community.id);
            },
          ),
        ),
      ],
    );

    _handleLeaveCommunity(MainModel model) async {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(confirmLeaveCommunityText),
              content: Text(
                  'Are you sure you want to leave the ${community
                      .name} community?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelText)),
                FlatButton(
                  onPressed: () {
                    model.leaveCommunity(community.id, model.currentUser.id);
                    Navigator.pop(context);
                  },
                  child: Text(leaveText),
                )
              ],
            );
          });
    }

    final _leaveButton =
    ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return model.joinedCommunities.contains(community.id)
          ? IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () => _handleLeaveCommunity(model),
      )
          : Container();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(community.name),
        actions: <Widget>[_leaveButton],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              _imageSection,
              _titleSection,
              _membersSection,
              _joinButtonSection
            ],
          ),
        ),
      ),
    );
  }
}