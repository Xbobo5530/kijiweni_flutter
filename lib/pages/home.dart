import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/explore_view.dart';
import 'package:kijiweni_flutter/views/home_view.dart';
import 'package:kijiweni_flutter/views/user_profile_view.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'HomePage:';

class HomePage extends StatelessWidget {
  final _userSection = Padding(
    padding: const EdgeInsets.all(8.0),
    child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoggedIn
            ? CircleAvatar(
          backgroundImage: NetworkImage(model.currentUser.userImageUrl),
        )
            : IconButton(
          icon: Icon(Icons.account_circle),
          iconSize: 30.0,
          onPressed: () {},
        );
      },
    ),
  );

  final _appBar = AppBar(
    title: Text(APP_NAME),
    leading: Icon(Icons.forum),
    actions: <Widget>[],
  );

  final _bottomNavSection = ScopedModelDescendant<MainModel>(
    builder: (BuildContext context, Widget child, MainModel model) {
      return BottomNavigationBar(
          currentIndex: model.currentNavItem,
          onTap: (selectedNavItem) {
            model.setSelectedNavItem(selectedNavItem);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text(homeText)),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text(exploreText)),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text(meText)),
          ]);
    },
  );

  final _bodySection = ScopedModelDescendant<MainModel>(
    builder: (BuildContext context, Widget child, MainModel model) {
      switch (model.currentNavItem) {
        case NAV_ITEM_HOME:
          return HomeView();
        case NAV_ITEM_EXPLORE:
          return ExploreView();
        case NAV_ITEM_ME:
          return UserProfileView();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      bottomNavigationBar: _bottomNavSection,
      body: _bodySection,
    );
  }
}
