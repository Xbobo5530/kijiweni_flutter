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

  const JoinButtonView({Key key, this.community}) : super(key: key);

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
          model.sortedCommunities(model.currentUser);
      }

      return Builder(builder: (context) {
        return FlatButton(
          onPressed: () => model.joiningCommunityStatus == StatusCode.waiting
              ? null
              : _handleJoinCommunity(model, context),
          child: model.joiningCommunityStatus == StatusCode.waiting
              ? MyProgressIndicator(
                  color: primaryColor,
                  size: 15.0,
                )
              : Text(joinText),
          textColor: primaryColor,
        );
      });
    }));
  }
}
