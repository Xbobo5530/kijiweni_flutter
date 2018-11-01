import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_field.dart';
import 'package:kijiweni_flutter/views/chat_history.dart';

class ChatPage extends StatelessWidget {
  final User user;

  ChatPage({this.user});

  @override
  Widget build(BuildContext context) {
    var chatHistorySection = new ChatHistoryView();
    var chatFieldSection = new ChatFieldView();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(APP_NAME),
      ),
      body: SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: chatHistorySection),
            chatFieldSection,
          ],
        ),
      ),
    );
  }
}
