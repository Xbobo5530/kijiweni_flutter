import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/pages/community_page.dart';
import 'package:kijiweni_flutter/src/pages/home.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(Kijiweni(model: MainModel())));
}

class Kijiweni extends StatelessWidget {
  final MainModel model;

  Kijiweni({this.model});
  @override
  Widget build(BuildContext context) {
    print('at Kijiweni');
    // if (model.deepLinkedCommunityId != null) _handleDeepLink();
    bool hasDeepLink = model.deepLinkedCommunityId != null;

    print('at main, hasDeepLink is:: $hasDeepLink');
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          title: APP_NAME,
          theme: ThemeData(primaryColor: primaryColor),
          // home: HomePage()
          initialRoute: hasDeepLink ? 'communityPage':  '/',
          routes: {
            '/': (context) => HomePage(),
            'communityPage': (context) => CommunityPage(
                  communityId:  model.deepLinkedCommunityId,
                ),
          },
        ));
  }
}
