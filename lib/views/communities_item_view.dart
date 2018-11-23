import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/community_page.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunitiesItemView extends StatelessWidget {
  final Community community;

  CommunitiesItemView({this.community});

  @override
  Widget build(BuildContext context) {
    _goToLogin() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => LoginPage(), fullscreenDialog: true));

    _goToCommunity() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => CommunityPage(community: community)));

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Column(
          children: <Widget>[
            SizedBox(height: 8.0,),
            community.imageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(community.imageUrl),
                )
              : CircularButton(
                size: 80,
                elevation: 0.0,
                icon: Icon(Icons.people, size: 40),
              ),
            ListTile(
              onTap: model.isLoggedIn ? () => _goToCommunity() : () => _goToLogin(),
              // leading: ,
              title: Text(community.name),
              subtitle: community.description != null
                  ? Text(community.description)
                  : Container(),
            ),
          ],
        );
      },
    );
  }
}
