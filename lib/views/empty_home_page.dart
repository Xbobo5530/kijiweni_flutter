import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/create_community.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyHomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToLoginPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoginPage(), fullscreenDialog: true));
    }

    _goToCreateCommunityPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CreateCommunityPage(), fullscreenDialog: true));
    }

    _buildButton(String label, Color color, IconData iconData,
            GestureTapCallback onTap) =>
        InkWell(
          onTap: onTap,
          child: Column(
            children: <Widget>[
              CircularButton(
                size: 150.0,
                elevation: 0.0,
                icon: Icon(
                  iconData,
                  size: 80,
                ),
                color: color,
              ),
              ListTile(
                title: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton(exploreHint, Colors.orange, Icons.search,
                  () => model.setSelectedNavItem(1)),
              _buildButton(
                  createHint,
                  Colors.lightGreen,
                  Icons.group_add,
                  model.isLoggedIn
                      ? () => _goToCreateCommunityPage()
                      : () => _goToLoginPage())

              //_createButton
            ],
          ),
    );
  }
}
