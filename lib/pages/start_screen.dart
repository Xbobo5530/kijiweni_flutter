import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/views/login_screen.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:

            /// this part should be replaced with a pageView
            /// that will have the initial tutorial as well as the
            /// login page for when the user has finished going through
            /// the tutorial //todo create tutorial
            LoginPage());
  }
}
