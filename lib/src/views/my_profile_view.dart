import 'package:flutter/material.dart';

import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/login_screen.dart';
import 'package:kijiweni_flutter/src/views/user_profile_view.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToLogin() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => LoginPage(), fullscreenDialog: true));

    final _loginView = InkWell(
      onTap: () => _goToLogin(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            shape: CircleBorder(),
            elevation: 4.0,
            child: Container(
              width: 150.0,
              height: 150.0,
              child: Icon(Icons.lock_open, size: 80.0),
              decoration:
                  BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
            ),
          ),
          ListTile(
            title: Text(
              loginText,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoggedIn
            ? UserProfileView(user: model.currentUser, isMe: model.currentUser != null,)
            : _loginView;
      },
    );
  }
}
