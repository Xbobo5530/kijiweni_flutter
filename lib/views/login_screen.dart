import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/home.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'LoginPage:';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text(errorMessageText));

    _handleGoogleSignIn(MainModel model) async {
      await model.signInWithGoogle();
      switch (model.loginStatus) {
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(snackBar);
          break;
        case StatusCode.success:
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
          break;
        default:
          print('$tag login status is ${model.loginStatus}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loginText),
      ),
      body: Center(
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            print('$tag loginStatus is ${model.loginStatus}');
            return RaisedButton(
                color: primaryColor,
                textColor: Colors.white,
                child: model.loginStatus == StatusCode.waiting
                    ? MyProgressIndicator(size: 15.0, color: Colors.white)
                    : Text(googleSignInText),
                onPressed: () => _handleGoogleSignIn(model));
          },
        ),
      ),
    );
  }
}
