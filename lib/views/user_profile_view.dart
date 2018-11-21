import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/communities_count.dart';
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

    Widget _buildMyCommunitiesListItems(
        MainModel model, List<Community> communities) {
      return Column(
        children: communities.map(_buildCommunityListItem).toList(),
      );
    }

    Widget _buildMyCommunitiesSection(MainModel model) {
      final userId = model.currentUser.id;
      Future<List<Community>> myCommunities =
          model.getUserCommunitiesFor(model.currentUser.id);
      return ExpansionTile(
        title: Text(myCommunitiesText),
        leading: CommunitiesCountView(key: Key(userId), userId: userId),
        children: <Widget>[
          FutureBuilder(
            future: myCommunities,
            initialData: List<Community>(),
            builder: ((_, AsyncSnapshot<List<Community>> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Text(loadingText),
                );
              List<Community> myCommunities = snapshot.data;
              return _buildMyCommunitiesListItems(model, myCommunities);
            }),
          )
        ],
      );
    }

    Widget _buildImageSection(MainModel model) => Container(
          width: 120.0,
          height: 120.0,
          child: Material(
            elevation: 4.0,
            shape: CircleBorder(),
            child: model.currentUser != null
                ? CircleAvatar(
                    backgroundColor: green,
                    backgroundImage: NetworkImage(model.currentUser.imageUrl),
                  )
                : Icon(
                    Icons.people,
                    size: 50.0,
                  ),
          ),
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
        return model.isLoggedIn ? _buildUserProfilePage(model) : _loginView;
      },
    );
  }
}
