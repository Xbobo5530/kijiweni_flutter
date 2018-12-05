import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/pages/community_info.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/views/community_timeline.dart';
import 'package:kijiweni_flutter/src/views/error_view.dart';
import 'package:kijiweni_flutter/src/views/input_field.dart';
import 'package:kijiweni_flutter/src/views/waiting_view.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityPage extends StatelessWidget {
  final Community community;
  final String communityId;

  CommunityPage({Key key, this.community, this.communityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _buildInfoButton(Community targetCommunity) =>
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) =>
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CommunityInfoPage(
                              community: targetCommunity,
                              isAdmin: model.isLoggedIn &&
                                  model.currentUser.id ==
                                      targetCommunity.createdBy,
                            ),
                        fullscreenDialog: true)),
              ),
        );

    _buildAppBar(Community targetCommunity) => AppBar(
          elevation: 0,
          title: Text(targetCommunity.name),
          actions: <Widget>[_buildInfoButton(targetCommunity)],
        );

    _buildBody(Community targetCommunity) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: CommunityTimelineView(
              community: targetCommunity,
            )),
            InputFieldView(
              community: targetCommunity,
            ),
          ],
        );

    final _loadCommunityFromInitLink = ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => FutureBuilder<Community>(
            future: model.communityFromId(communityId),
            builder: (context, snapshot) {
              // reset the deep link
              print('_loadCommunityFromInitLink');
              model.resetInitialLinkData();
              if (!snapshot.hasData) return WaitingView();
              if (snapshot.data == null) return ErrorView();

              Community mCommunity = snapshot.data;
              return Scaffold(
                backgroundColor: primaryColor,
                appBar: _buildAppBar(mCommunity),
                body: _buildBody(mCommunity),
              );
            }));

    final _loadLocalCommunity = Scaffold(
      backgroundColor: primaryColor,
      appBar: _buildAppBar(community),
      body: _buildBody(community),
    );

    return community != null ? _loadLocalCommunity : _loadCommunityFromInitLink;
  }
}
