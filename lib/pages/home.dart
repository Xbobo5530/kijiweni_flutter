import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/create_community.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/explore_view.dart';
import 'package:kijiweni_flutter/views/home_view.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:kijiweni_flutter/views/user_profile_view.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToCreateCommunity() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CreateCommunityPage(), fullscreenDialog: true));

    _goToLogin() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => LoginPage(), fullscreenDialog: true));

    _handleLogout(MainModel model) async {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.warning, color: Colors.red),
                  ),
                  Text(logoutText)
                ],
              ),
              content: Text(confirmLogoutText),
              actions: <Widget>[
                FlatButton(
                  textColor: primaryColor,
                  onPressed: () => Navigator.pop(context),
                  child: Text(cancelText),
                ),
                FlatButton(
                  textColor: Colors.red,
                  onPressed: () {
                    model.logout();
                    Navigator.pop(context);
                  },
                  child: Text(logoutText),
                )
              ],
            );
          });
    }

    final _appBarAction = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        switch (model.currentNavItem) {
          case NAV_ITEM_HOME:
            return Container();
            break;
          case NAV_ITEM_EXPLORE:
            return IconButton(
              onPressed: model.isLoggedIn
                  ? () => _goToCreateCommunity()
                  : () => _goToLogin(),
              icon: Icon(Icons.add),
            );
            break;
          case NAV_ITEM_ME:
            return model.isLoggedIn
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => _handleLogout(model),
                  )
                : Container();
            break;
        }
      },
    );

    final _appBar = AppBar(
      title: Text(APP_NAME),
      leading: Icon(Icons.forum),
      actions: <Widget>[_appBarAction],
    );

    final _bottomNavSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return BottomNavigationBar(
            fixedColor: Colors.lightGreen,
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
                  icon: Icon(Icons.person), title: Text(meText)),
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
            return MyProfileView();
        }
      },
    );

    return Scaffold(
      appBar: _appBar,
      bottomNavigationBar: _bottomNavSection,
      body: _bodySection,
    );
  }
}
