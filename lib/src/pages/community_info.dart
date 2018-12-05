import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/community_basic_section.dart';
import 'package:kijiweni_flutter/src/views/community_image_section.dart';
import 'package:kijiweni_flutter/src/views/community_member_section.dart';
import 'package:kijiweni_flutter/src/views/join_button.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

// const _tag = 'CommunityInfoPage:';

class CommunityInfoPage extends StatelessWidget {
  final Community community;
  final bool isAdmin;
  CommunityInfoPage({this.community, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final _joinButtonSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.joinedCommunitiesMap.containsKey(community.id)
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 80),
                child: JoinButtonView(
                    community: community, source: SourcePage.infopage));
      },
    );

    _finishLeaveCommunity(MainModel model) async {
      StatusCode leaveCommunityStatus =
          await model.leaveCommunity(community, model.currentUser);

      switch (leaveCommunityStatus) {
        case StatusCode.success:
          await model.updatedJoinedCommunities(model.currentUser);
          break;
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
          break;
        default:
          print('leaveCommunityStatus is: $leaveCommunityStatus');
      }
    }

    final _actions = <Widget>[
      FlatButton(
          onPressed: () => Navigator.pop(context, false),
          textColor: primaryColor,
          child: Text(cancelText)),
      FlatButton(
        onPressed: () => Navigator.pop(context, true),
        textColor: Colors.red,
        child: Text(leaveText),
      )
    ];

    final _leaveCommunityDialogContent = Text(
        //'Are you sure you want to leave the ${community.name} community?'),
        'Unauhakika unataka kujitoa kwenye kijiwe cha ${community.name}?');

    _showLeaveCommunityDialog(MainModel model) async {
      bool shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(model.userCommunityStatus == StatusCode.waiting
                    ? waitText
                    : confirmLeaveCommunityText),
                content: _leaveCommunityDialogContent,
                actions: _actions,
              ));
      if (shouldLeave) _finishLeaveCommunity(model);
    }

    final _leaveButton =
        ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return model.joinedCommunitiesMap.containsKey(community.id)
          ? model.userCommunityStatus == StatusCode.waiting
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyProgressIndicator(
                      strokewidth: 2,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _showLeaveCommunityDialog(model),
                )
          : Container();
    });

    final _shareButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 80.0),
        child: ScopedModelDescendant<MainModel>(
          builder: (_, __, model) => RaisedButton(
                child: Text(inviteText),
                color: primaryColor,
                textColor: Colors.white,
                onPressed: () =>
                    model.shareCommunity(community, model.currentUser),
              ),
        ));

    final _appBar = AppBar(
      title: Text(community.name),
      actions: <Widget>[_leaveButton],
    );

    return Scaffold(
      appBar: _appBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            CommunityImageSectionView(community: community),
            CommunityDetailsSectionView(community: community, isAdmin: isAdmin),
            _joinButtonSection,
            _shareButton,
            CommunityMemberSectionView(community: community),
          ],
        ),
      ),
    );
  }
}
