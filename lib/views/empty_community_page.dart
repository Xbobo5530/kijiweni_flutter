import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
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
            
            CircularButton(
              elevation: 4.0,
              size: 150.0,
              color: Colors.lightGreen,
              icon: Icon(Icons.people, size: 80.0)
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
