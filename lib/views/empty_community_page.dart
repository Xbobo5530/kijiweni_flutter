import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyCommunityPage extends StatelessWidget {
  final Community community;

  EmptyCommunityPage({this.community});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              shape: CircleBorder(),
              elevation: 4.0,
              child: Container(
                width: 150.0,
                height: 150.0,
                child: Icon(Icons.people, size: 80.0),
                decoration: BoxDecoration(
                    color: Colors.lightGreen, shape: BoxShape.circle),
              ),
            ),
            Padding(
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
            )
          ],
        );
      },
    );
  }
}
