import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class JoinButtonView extends StatelessWidget {
  final String communityId;

  JoinButtonView({this.communityId});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: ((context, child, model) {
      _handleJoinCommunity(MainModel model, BuildContext context) async {
        final joinCommunityResult =
            await model.joinCommunity(communityId, model.currentUser.id);
        if (joinCommunityResult == StatusCode.failed)
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(failedToJoinCommunityText)));
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
