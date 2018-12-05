import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class JoinButtonView extends StatelessWidget {
  final Community community;
  final SourcePage source;

  const JoinButtonView({
    Key key,
    this.community,
    this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: ((context, child, model) {
      _handleJoinCommunity(MainModel model, BuildContext context) async {
        final joinCommunityResult =
            await model.joinCommunity(community, model.currentUser);
        if (joinCommunityResult == StatusCode.failed)
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(failedToJoinCommunityText)));
        if (joinCommunityResult == StatusCode.success)
          model.updatedJoinedCommunities(model.currentUser);
      }

      _handleButtonColor() {
        switch (source) {
          case SourcePage.infopage:
          case SourcePage.homePage:
            return primaryColor;
            break;
          case SourcePage.communityPage:
            return null ;
            break;
          default:
            return null;
        }
      }

      _handleTextColor() {
        switch (source) {
          case SourcePage.infopage:
          case SourcePage.homePage:
            return Colors.white;
            break;
          case SourcePage.communityPage:
            return primaryColor;
            break;
          default:
            return primaryColor;
        }
      }

      return Builder(builder: (context) {
        return FlatButton(
          onPressed: () => model.userCommunityStatus == StatusCode.waiting
              ? null
              : _handleJoinCommunity(model, context),
          child: model.userCommunityStatus == StatusCode.waiting
              ? MyProgressIndicator(
                  color: _handleTextColor(),
                  size: 15,
                  strokewidth: 2,
                )
              : Text(joinText),
          textColor: _handleTextColor(),
          color: _handleButtonColor(),
        );
      });
    }));
  }
}
