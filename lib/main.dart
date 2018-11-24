import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/community_page.dart';
import 'package:kijiweni_flutter/pages/home.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(Kijiweni(
      model: MainModel(),
    ));

class Kijiweni extends StatelessWidget {
  final MainModel model;

  Kijiweni({this.model});
  @override
  Widget build(BuildContext context) {
    print('at Kijiweni');

    _handleDeepLink() {
      model
          .communityFromId(model.deepLinkedCommunityId)
          .catchError((Community community) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contest) => CommunityPage(community: community)));
      });
    }

    if (model.deepLinkedCommunityId != null) _handleDeepLink();

    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
            title: APP_NAME,
            theme: ThemeData(primaryColor: primaryColor),
            home: HomePage()));
  }
}
