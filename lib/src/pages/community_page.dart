import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/pages/community_info.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/views/community_timeline.dart';
import 'package:kijiweni_flutter/src/views/input_field.dart';

class CommunityPage extends StatelessWidget {
  final Community community;

  CommunityPage({Key key, this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 0.0,
      title: Text(community.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CommunityInfoPage(community: community),
                  fullscreenDialog: true)),
        )
      ],
    );

    final _body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: CommunityTimelineView(
          community: community,
        )),
        InputFieldView(
          community: community,
          
        ),
      ],
    );
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _appBar,
      body: _body,
    );
  }
}
