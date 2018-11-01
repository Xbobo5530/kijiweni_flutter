import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/create_community.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyHomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToLoginPage() {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }

    _goToCreateCommunityPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CreateCommunityPage(), fullscreenDialog: true));
    }

    final _exploreButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return InkWell(
          onTap: () => model.setSelectedNavItem(1),
          child: Column(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                elevation: 4.0,
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: Icon(Icons.search, size: 80.0),
                  decoration: BoxDecoration(
                      color: Colors.orange, shape: BoxShape.circle),
                ),
              ),
              ListTile(
                title: Text(
                  exploreHint,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );

    final _createButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return InkWell(
          onTap: model.isLoggedIn
              ? () => _goToCreateCommunityPage()
              : () => _goToLoginPage(),
          child: Column(
            children: <Widget>[
              Material(
                elevation: 4.0,
                shape: CircleBorder(),
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: Icon(
                    Icons.group_add,
                    size: 80.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.lightGreen, shape: BoxShape.circle),
                ),
              ),
              ListTile(
                  title: Text(
                    createHint,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        );
      },
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[_exploreButton, _createButton],
      ),
    );
  }
}
