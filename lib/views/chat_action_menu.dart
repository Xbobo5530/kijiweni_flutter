import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_bubblt_action_item.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ChatActionMenuView:';

class ChatActionMenuView extends StatelessWidget {
  final Color color;
  final Chat chat;

  ChatActionMenuView({Key key, this.color, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return PopupMenuButton(
            onSelected: (selectedMenuAction) {
              print('$_tag $selectedMenuAction has been selected');

              switch (selectedMenuAction) {
                case ChatMenuAction.like:
                  model.likeMessage(chat, model.currentUser.id);
                  break;
              }

              /// todo check the returning value,
              /// probably will have to switch between the returning values
              /// will also have to nest this widget inside a scoped model descendant
            },
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: color,
            ),
            itemBuilder: (_) {
              return <PopupMenuItem<ChatMenuAction>>[
                PopupMenuItem(
                    value: ChatMenuAction.like,
                    child: ChatBubbleActionItemView(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      color: Colors.red,
                      label: likeText,
                    )),
                PopupMenuItem(
                  value: ChatMenuAction.share,
                  child: ChatBubbleActionItemView(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    color: Colors.orange,
                    label: shareText,
                  ),
                ),
                PopupMenuItem(
                  value: ChatMenuAction.reply,
                  child: ChatBubbleActionItemView(
                    icon: Icon(
                      Icons.reply,
                      color: Colors.white,
                    ),
                    color: Colors.blue,
                    label: replyText,
                  ),
                )
              ];
            });
      },
    );
  }
}

enum ChatMenuAction { like, share, reply }
