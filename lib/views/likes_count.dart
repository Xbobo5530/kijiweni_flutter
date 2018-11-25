import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatLikesCountView extends StatelessWidget {
  final Chat chat;

  ChatLikesCountView({this.chat}) : assert(chat != null);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return FutureBuilder<int>(
        future: model.getChatLikesCountFor(chat),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Container();
          return snapshot.data == 0
              ? Container()
              : Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        size: 14.0,
                        color: Colors.red,
                      ),
                      Text(
                        '${snapshot.data}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                );
        },
      );
    });
  }
}
