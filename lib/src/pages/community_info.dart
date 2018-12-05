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
  final bool isAdmin;
  CommunityInfoPage({this.community, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final _editController = TextEditingController();

    _getCurrentData(DetailType type) {
      switch (type) {
        case DetailType.name:
          return community.name;
          break;
        case DetailType.description:
          return community.description != null
              ? community.description
              : communityDescriptionText;
          break;
        default:
          return editText;
      }
    }

    Future<bool> _handleEditDialog(DetailType type) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(editText),
              content: TextField(
                maxLines: type == DetailType.name ? 1 : null,
                controller: _editController,
                decoration: InputDecoration(hintText: _getCurrentData(type)),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(cancelText),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text(submitText),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));

    _getEditedCommunity(DetailType type, String newData) {
      switch (type) {
        case DetailType.name:
          community.name = newData;
          return community;
          break;
        case DetailType.description:
          community.description = newData;
          return community;
          break;
        default:
          print('error on type: $type');
          return community;
      }
    }

    _showEditDialog(MainModel model, DetailType detailType) async {
      bool startEditing = await _handleEditDialog(detailType);
      if (!startEditing) return null;
      final String newData = _editController.text.trim();
      if (newData.isEmpty) return null;
      Community editedCommunity = _getEditedCommunity(detailType, newData);
      StatusCode editStatus =
          await model.editCommunityInfo(editedCommunity, detailType);
      if (editStatus == StatusCode.failed) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }

    final _imageSection = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: community.imageUrl != null
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
              ));

    _buildEditButton(DetailType type) => ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black12,
              ),
              onPressed: () => _showEditDialog(model, type),
            ));

    final _titleSection =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      isAdmin
          ? SizedBox(
              width: 40,
            )
          : Container(),
      Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
        child: Text(
          community.name,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      isAdmin ? _buildEditButton(DetailType.name) : Container(),
    ]);

    final _descSection = community.description != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                isAdmin
                    ? SizedBox(
                        width: 40,
                      )
                    : Container(),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.4),
                  child: Text(
                    community.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                isAdmin ? _buildEditButton(DetailType.description) : Container()
              ])
        : Container();

    Widget _buildMemberListItem(User member) {
      return ListTile(
        leading: member.imageUrl != null
            ? CircleAvatar(
                backgroundColor: green,
                backgroundImage: NetworkImage(member.imageUrl),
              )
            : CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 32,
                )),
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
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 80),
                child: JoinButtonView(
                    community: community, source: SourcePage.infopage));
      },
    );

    _finishLeaveCommunity(MainModel model) async {
      StatusCode leaveCommunityStatus =
          await model.leaveCommunity(community, model.currentUser);

      switch (leaveCommunityStatus) {
        case StatusCode.success:
          await model.updatedJoinedCommunities(model.currentUser);
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
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 80.0),
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
            _descSection,
            _joinButtonSection,
            _shareButton,
            _membersSection,
          ],
        ),
      ),
    );
  }
}
