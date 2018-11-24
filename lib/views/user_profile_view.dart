import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/joined_list_item.dart';

import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToLogin() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => LoginPage(), fullscreenDialog: true));

    final _loginView = InkWell(
      onTap: () => _goToLogin(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            shape: CircleBorder(),
            elevation: 4.0,
            child: Container(
              width: 150.0,
              height: 150.0,
              child: Icon(Icons.lock_open, size: 80.0),
              decoration:
                  BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
            ),
          ),
          ListTile(
            title: Text(
              loginText,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );

    Widget _buildCommunityListItem(Community community) {
      return ListTile(
//        onTap: model.isLoggedIn ? () => _goToCommunity() : () => _goToLogin(),
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

    Widget _buildMyCommunitiesSection(MainModel model) {
      //  model.getUserCommunitiesFor(model.currentUser);
      return model.myCommunities.length == 0
          ? Container()
          : ExpansionTile(
              title: Text(myCommunitiesText),
              leading: Chip(
                label: Text('${model.myCommunities.length}'),
              ),
              children: model.myCommunities
                  .map((community) => JoinedCommunityListItemView(
                        community: community,
                        key: Key(community.id),
                      ))
                  .toList(),
            );
    }

    Widget _buildImageSection(MainModel model) =>
        model.currentUser == null || model.currentUser.imageUrl == null
            ? CircularButton(
                size: 120.0,
                elevation: 0.0,
                icon: Icon(
                  Icons.person,
                  size: 70.0,
                ),
              )
            : CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.lightGreen,
                backgroundImage: NetworkImage(model.currentUser.imageUrl),
              );

    Widget _buildInfoSection(MainModel model) => ListTile(
        title: model.currentUser != null
            ? Text(
                model.currentUser.name,
                textAlign: TextAlign.center,
              )
            : Container());

    Widget _buildUserProfilePage(MainModel model) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                _buildImageSection(model),
                _buildInfoSection(model),
                _buildMyCommunitiesSection(model),
              ],
            ),
          ),
        );

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        // print('${model.currentUser.toString()}');
        return model.isLoggedIn ? _buildUserProfilePage(model) : _loginView;
      },
    );
  }
}
