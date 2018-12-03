import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/views/empty_home_page.dart';
import 'package:kijiweni_flutter/src/views/joined_list_item.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build is called');

    return Scaffold(body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (!model.isLoggedIn) return EmptyHomePageView();

      return FutureBuilder<List<Community>>(
        initialData: model.cachedJoinedCommunities,
        future: model.updatedJoinedCommunities(model.currentUser),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Center(
                  child: MyProgressIndicator(),
                )
              : snapshot.data.length == 0
                  ? EmptyHomePageView()
                  : ListView(
                      children: snapshot.data
                          .map(
                            (community) => JoinedCommunityListItemView(
                                community: community, key: Key(community.id)),
                          )
                          .toList());
        },
      );
    }));
  }
}
