import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
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

    _handleGoogleSignIn(MainModel model, BuildContext context) async {
      await model.loginWithGoogle();
      switch (model.loginStatus) {
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(snackBar);
          break;
        case StatusCode.success:
          Navigator.pop(context);
          break;
        default:
          print('$tag login status is ${model.loginStatus}');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(loginText),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return InkWell(
              onTap: () => _handleGoogleSignIn(model, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: model.loginStatus == StatusCode.waiting
                          ? Center(
                              child: MyProgressIndicator(
                                  size: 20.0, color: primaryColor))
                          : Icon(Icons.track_changes, size: 80.0),
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      model.loginStatus == StatusCode.waiting
                          ? waitText
                          : signInWithGoogleText,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
