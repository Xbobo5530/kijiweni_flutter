import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/pages/community_info.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/views/community_timeline.dart';
import 'package:kijiweni_flutter/views/input_field.dart';

class CommunityPage extends StatelessWidget {
  final Community community;

  CommunityPage({Key key, this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: CommunityTimelineView(
            community: community,
          )),
          InputFieldView(
            communityId: community.id,
          ),
        ],
      ),
    );
  }
}
