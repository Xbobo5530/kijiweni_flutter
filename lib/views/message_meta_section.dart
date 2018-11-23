import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/views/likes_count.dart';

class MessageMetaSectionView extends StatelessWidget {
  final Chat chat;

  MessageMetaSectionView({@required this.chat}) : assert(chat != null);

  @override
  Widget build(BuildContext context) {
    final DateTime _createdAt =
        DateTime.fromMillisecondsSinceEpoch(chat.createdAt);
    return Positioned(
      bottom: 0.0,
      right: 8.0,
      child: Row(
        children: <Widget>[
          Text('${_createdAt.hour}:${_createdAt.minute}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.0,
              )),
          SizedBox(width: 3.0),
          ChatLikesCountView(chat: chat)
        ],
      ),
    );
  }
}
