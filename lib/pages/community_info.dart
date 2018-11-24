import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/join_button.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityInfoPage extends StatelessWidget {
  final Community community;

  CommunityInfoPage({this.community});

  @override
  Widget build(BuildContext context) {
    final _imageSection = community.imageUrl != null
        ? CircleAvatar(
            radius: 70.0,
            backgroundColor: Colors.lightGreen,
            backgroundImage: NetworkImage(community.imageUrl),
          )
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
                    children: snapshot.data
                                    .map(_buildMemberListItem)
                                    .toList(),

                    
                  ),
          ),
    );

    
    final _joinButtonSection = Row(
      children: <Widget>[
        Expanded(
          child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return model.joinedCommunities.containsKey(community.id)
                  ? Container()
                  : JoinButtonView(community: community);
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
                  'Are you sure you want to leave the ${community.name} community?'),
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

    final _leaveButton =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return model.joinedCommunities.containsKey(community.id)
          ? IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _handleLeaveCommunity(model),
            )
          : Container();
    });

    final _shareSection = ScopedModelDescendant<MainModel>(
      builder: (_,__,model)=>RaisedButton(
        child: Text(invtiteText),
        color: primaryColor,
        textColor: Colors.white,
        onPressed: ()=>model.shareCommunity(community, model.currentUser),
      ),
    );

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
              _shareSection
            ],
          ),
        ),
      ),
    );
  }
}
