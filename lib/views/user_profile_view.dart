import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToLogin() =>
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => LoginPage(), fullscreenDialog: true));

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

    Widget _buildUserProfilePage(MainModel model) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 120.0,
                  height: 120.0,
                  child: Material(
                    elevation: 4.0,
                    shape: CircleBorder(),
                    child: model.currentUser != null
                        ? CircleAvatar(
                      backgroundImage:
                      NetworkImage(model.currentUser.userImageUrl),
                    )
                        : Icon(Icons.people),
                  ),
                ),
                ListTile(
                    title: Text(
                  model.currentUser.username,
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
        );

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoggedIn ? _buildUserProfilePage(model) : _loginView;
      },
    );
  }
}
