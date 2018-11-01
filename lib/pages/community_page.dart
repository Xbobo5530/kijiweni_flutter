import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/community_timeline.dart';
import 'package:kijiweni_flutter/views/input_field.dart';

class CommunityPage extends StatelessWidget {
  final Community community;

  CommunityPage({Key key, this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatHistorySection = CommunityTimelineView();
    final chatFieldSection = InputFieldView();

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: chatHistorySection),
            chatFieldSection,
          ],
        ),
      ),
    );
  }
}
