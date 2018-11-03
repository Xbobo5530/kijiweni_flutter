import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityMembersCountView extends StatefulWidget {
  final Community community;

  CommunityMembersCountView({Key key, this.community}) : super(key: key);

  @override
  _CommunityMembersCountViewState createState() =>
      _CommunityMembersCountViewState();
}

class _CommunityMembersCountViewState extends State<CommunityMembersCountView> {
  bool _isDisposed = false;
  int _memberCount = 0;

  @override
  Widget build(BuildContext context) {
    _getCount(MainModel model) async {
      final count = await model.getCommunityMembersCountFor(widget.community);
      if (!_isDisposed)
        setState(() {
          _memberCount = count;
        });
    }

    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      _getCount(model);
      return Chip(label: Text('$_memberCount'));
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
  }
}
