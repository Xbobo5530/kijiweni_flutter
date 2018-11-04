import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityMembersCountView extends StatelessWidget {
  final Community community;
  CommunityMembersCountView({Key key, this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return FutureBuilder(
          future: model.getCommunityMembersCountFor(community),
          builder: ((context, snapshot) {
            if (!snapshot.hasData)
              return MyProgressIndicator(
                size: 15.0,
                color: Colors.grey,
              );
            return Chip(label: Text('${snapshot.data}'));
          }));
    });
  }
}
