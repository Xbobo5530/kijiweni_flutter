import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/pages/community_page.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/login_screen.dart';
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
        return InkWell(
          onTap: model.isLoggedIn ? () => _goToCommunity() : () => _goToLogin(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              community.imageUrl != null
                  ? CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    radius: 40.0,
                      backgroundImage: NetworkImage(community.imageUrl),
                    )
                  : CircularButton(
                      size: 80,
                      elevation: 0.0,
                      icon: Icon(Icons.people, size: 40),
                    ),
              ListTile(
                title: Text(community.name, textAlign: TextAlign.center,),
                subtitle: community.description != null
                    ? Text(community.description, textAlign: TextAlign.center,
                    maxLines: 3,)
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
