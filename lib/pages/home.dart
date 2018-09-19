import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/values/strings.dart';
import 'package:kijiweni_flutter/views/chat_field.dart';
import 'package:kijiweni_flutter/views/chat_history.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var topSection = new ChatHistoryView();
    var bottomSection = new ChatFieldView();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(APP_NAME),
      ),
      body: SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: topSection),
            bottomSection,
          ],
        ),
      ),
    );
  }
}
