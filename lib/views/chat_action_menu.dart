import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_bubblt_action_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

// const _tag = 'ChatActionMenuView:';

class ChatActionMenuView extends StatelessWidget {
  final Color color;
  final Chat chat;

  ChatActionMenuView({Key key, this.color, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<ChatMenuAction> _buildLikeButton(MainModel model) =>
        PopupMenuItem(
            value: ChatMenuAction.like,
            child: FutureBuilder<bool>(
              future: model.hasLikedChat(model.currentUser.id, chat),
              initialData: false,
              builder: (_, snapshot) {
                final _hasLiked = snapshot.data;
                return ChatBubbleActionItemView(
                  icon: Icon(
                    Icons.favorite,
                    color: _hasLiked ? Colors.white : Colors.white,
                  ),
                  color: _hasLiked ? Colors.grey : Colors.red,
                  label: _hasLiked ? dislikeText : likeText,
                );
              },
            ));

    PopupMenuItem<ChatMenuAction> _buildActionButton(ChatMenuAction action,
            Icon icon, Color backgroundColor, String label) =>
        PopupMenuItem(
          value: action,
          child: ChatBubbleActionItemView(
            icon: icon,
            color: backgroundColor,
            label: label,
          ),
        );

    _shareMessage() {
      //todo get short link
      //todo add share to project
      final url = 'testUrl'; //todo add app download link
      Share.share('${chat.message}\n$url');
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return PopupMenuButton(
            onSelected: (selectedMenuAction) {
              // print('$_tag $selectedMenuAction has been selected');

              switch (selectedMenuAction) {
                case ChatMenuAction.like:
                  model.handleLikeMessage(chat, model.currentUser.id);
                  break;
                case ChatMenuAction.reply:
                  model.replyMessage(chat);
                  break;
                case ChatMenuAction.share:
                  _shareMessage();
                  break;
              }
            },
            icon: Icon(
              Icons.more_horiz,
              color: color,
            ),
            itemBuilder: (_) {
              return <PopupMenuItem<ChatMenuAction>>[
                _buildLikeButton(model),
                _buildActionButton(
                    ChatMenuAction.share,
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    Colors.orange,
                    shareText),
                _buildActionButton(
                    ChatMenuAction.reply,
                    Icon(
                      Icons.reply,
                      color: Colors.white,
                    ),
                    Colors.blue,
                    replyText)
              ];
            });
      },
    );
  }
}
