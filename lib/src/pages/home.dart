import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/pages/create_community.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/app_info_view.dart';
import 'package:kijiweni_flutter/src/views/explore_view.dart';
import 'package:kijiweni_flutter/src/views/home_view.dart';
import 'package:kijiweni_flutter/src/views/login_screen.dart';
import 'package:kijiweni_flutter/src/views/my_profile_view.dart';
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

    _buildAppBarAction(MainModel model) => ScopedModelDescendant<MainModel>(
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

    
   

    _buildAppBar(MainModel model) => AppBar(
          title: Text(APP_NAME),
          leading: AppInfoView(),
          actions: <Widget>[_buildAppBarAction(model)],
        );

    _builBottomNavSection(MainModel model) => BottomNavigationBar(
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

    _buildBodySection(MainModel model) {
      switch (model.currentNavItem) {
        case NAV_ITEM_HOME:
          return HomeView();
        case NAV_ITEM_EXPLORE:
          return ExploreView();
        case NAV_ITEM_ME:
          return MyProfileView();
        default:
          return HomeView();
      }
    }

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => Scaffold(
            appBar: _buildAppBar(model),
            bottomNavigationBar: _builBottomNavSection(model),
            body: _buildBodySection(model),
          ),
    );
  }
}
