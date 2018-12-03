import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/join_button.dart';
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
        return model.joinedCommunities.containsKey(community.id)
            ? Container()
            : JoinButtonView(community: community);
      },
    );

    _handleLeaveCommunity(MainModel model) async {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(confirmLeaveCommunityText),
              content: Text(
                  //'Are you sure you want to leave the ${community.name} community?'),
                  'Unauhakika unataka kujitoa kwenye kijiwe cha ${community.name}?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    textColor: primaryColor,
                    child: Text(cancelText)),
                FlatButton(
                  onPressed: () {
                    model.leaveCommunity(community, model.currentUser);
                    Navigator.pop(context);
                  },
                  textColor: Colors.red,
                  child: Text(leaveText),
                )
              ],
            );
          });
    }

    _handleSelection(MainModel model, bool shouldDelete) async {
      switch (shouldDelete) {
        case true:
          StatusCode deleteCommunityStatus =
              await model.deleteCommunity(community, model.currentUser);

          switch (deleteCommunityStatus) {
            case StatusCode.success:
              if (community.imageUrl != null)
                await model.deleteAsset(community.imagePath);
              Navigator.popUntil(context, ModalRoute.withName('/'));
              break;
            case StatusCode.failed:
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage),
              ));
              break;
            default:
              print(
                  '$_tag unexpected deleteCommunityStatus: $deleteCommunityStatus');
          }
          break;
        default:
          print('$_tag shouldDelete is: $shouldDelete');
      }
    }

    _handleDeleteCommunity(MainModel model) async {
      bool shouldDelete = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(deleteCommunityText),
                content: Text(confirmDeleteCommunityMessage),
                actions: <Widget>[
                  FlatButton(
                    textColor: primaryColor,
                    child: Text(cancelText),
                    onPressed: () {
                      return Navigator.pop(context, false);
                    },
                  ),
                  FlatButton(
                    textColor: Colors.red,
                    child: Text(deleteText),
                    onPressed: () {
                      return Navigator.pop(context, true);
                    },
                  )
                ],
              ));

      _handleSelection(model, shouldDelete);
    }

    final _leaveButton =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return model.joinedCommunities.containsKey(community.id)
          ? community.createdBy == model.currentUser.id
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _handleDeleteCommunity(model),
                )
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _handleLeaveCommunity(model),
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
