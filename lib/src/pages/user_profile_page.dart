import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/views/user_profile.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: UserProfileView(user: user,),
    );
  }
}