import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyCommunityPage extends StatelessWidget {
  final Community community;

  EmptyCommunityPage({this.community});

  @override
  Widget build(BuildContext context) {
    final _imageSection = community.imageUrl != null
        ? Center(child : CircleAvatar(
            radius: 80.0,
            backgroundColor: Colors.lightGreen,
            backgroundImage: NetworkImage(community.imageUrl),
          ))
        : CircularButton(
            elevation: 4.0,
            size: 150.0,
            color: Colors.lightGreen,
            icon: Icon(Icons.people, size: 80.0));

    final _infoSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          community.name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        subtitle: community.description != null
            ? Text(
                community.description,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              )
            : Container(),
      ),
    );

    final _inviteButton = ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: RaisedButton(
            child: Text(inviteText),
            onPressed: () => model.shareCommunity(community, model.currentUser),
          )),
    );

    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        _imageSection,
        _infoSection,
        _inviteButton,
      ],
    );
  }
}
