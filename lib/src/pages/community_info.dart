import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/join_button.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CommunityInfoPage:';

class CommunityInfoPage extends StatelessWidget {
  final Community community;

  CommunityInfoPage({this.community});

  @override
  Widget build(BuildContext context) {
    final _imageSection = community.imageUrl != null
        ? Center(
            child: CircleAvatar(
            radius: 70.0,
            backgroundColor: Colors.lightGreen,
            backgroundImage: NetworkImage(community.imageUrl),
          ))
        : CircularButton(
            size: 120,
            elevation: 0.0,
            icon: Icon(
              Icons.people,
              size: 70.0,
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

    Widget _buildMemberListItem(User member) {
      return ListTile(
        leading: member.imageUrl != null
            ? CircleAvatar(
                backgroundColor: green,
                backgroundImage: NetworkImage(member.imageUrl),
              )
            : Icon(
                Icons.account_circle,
                size: 20.0,
              ),
        title: Text(member.name),
      );
    }

    final _membersSection = ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => FutureBuilder<List<User>>(
            future: model.getCommunityMembersFor(community),
            initialData: <User>[],
            builder: (_, snapshot) => snapshot.data.length == 0
                ? Container()
                : ExpansionTile(
                    title: Text(membersText),
                    leading: Chip(
                      label: Text('${snapshot.data.length}'),
                    ),
                    children: snapshot.data.map(_buildMemberListItem).toList(),
                  ),
          ),
    );

    final _joinButtonSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.joinedCommunitiesMap.containsKey(community.id)
            ? Container()
            : JoinButtonView(community: community);
      },
    );

    _finishLeaveCommunity(MainModel model) async {
      StatusCode leaveCommunityStatus =
          await model.leaveCommunity(community, model.currentUser);

      switch (leaveCommunityStatus) {
        case StatusCode.success:
          await model.updatedJoinedCommunities(model.currentUser);
          Navigator.pop(context);
          break;
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
          break;
        default:
          print('leaveCommunityStatus is: $leaveCommunityStatus');
      }
    }

    final _actions = <Widget>[
      FlatButton(
          onPressed: () => Navigator.pop(context, false),
          textColor: primaryColor,
          child: Text(cancelText)),
      FlatButton(
        onPressed: () => Navigator.pop(context, true),
        textColor: Colors.red,
        child: Text(leaveText),
      )
    ];

    final _content = Text(
        //'Are you sure you want to leave the ${community.name} community?'),
        'Unauhakika unataka kujitoa kwenye kijiwe cha ${community.name}?');

    _showLeaveCommunityDialog(MainModel model) async {
      bool shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(model.userCommunityStatus == StatusCode.waiting
                    ? waitText
                    : confirmLeaveCommunityText),
                content: _content,
                actions: _actions,
              ));
        if (shouldLeave) _finishLeaveCommunity(model);
    }

    final _leaveButton =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return model.joinedCommunitiesMap.containsKey(community.id)
          ? model.userCommunityStatus == StatusCode.waiting
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyProgressIndicator(
                      strokewidth: 2,
                      size: 15,
                      color: Colors.white,
                      
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _showLeaveCommunityDialog(model),
                )
          : Container();
    });

    final _shareButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
        child: ScopedModelDescendant<MainModel>(
          builder: (_, __, model) => RaisedButton(
                child: Text(inviteText),
                color: primaryColor,
                textColor: Colors.white,
                onPressed: () =>
                    model.shareCommunity(community, model.currentUser),
              ),
        ));

    final _appBar = AppBar(
      title: Text(community.name),
      actions: <Widget>[_leaveButton],
    );

    return Scaffold(
      appBar: _appBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            _imageSection,
            _titleSection,
            _membersSection,
            _joinButtonSection,
            _shareButton
          ],
        ),
      ),
    );
  }
}
