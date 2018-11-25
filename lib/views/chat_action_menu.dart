import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/chat_bubble_action_item.dart';

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

    // _shareMessage() {
    //   //todo get short link
    //   //todo add share to project
    //   final url = 'testUrl'; //todo add app download link
    //   Share.share('${chat.message}\n$url');
    // }

    _handleDelete(MainModel model) async {
      StatusCode deleteStatus = await model.deleteChat(chat);
      if (chat.fileType == FILE_TYPE_NO_FILE) return null;
      switch (deleteStatus) {
        case StatusCode.success:
          model.deleteAsset(chat.filePath);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(reportSubmittedMessage),
          ));
          break;
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
          break;
        default:
          print('$_tag unexpected status $deleteStatus');
      }
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return PopupMenuButton(
            onSelected: (selectedMenuAction) {
              switch (selectedMenuAction) {
                case ChatMenuAction.like:
                  model.handleLikeMessage(chat, model.currentUser.id);
                  break;
                case ChatMenuAction.reply:
                  model.replyMessage(chat);
                  break;
                // case ChatMenuAction.share:
                //   _shareMessage();
                //   break;
                case ChatMenuAction.delete:
                  _handleDelete(model);
                  break;
                case ChatMenuAction.report:
                  model.reportChat(chat, model.currentUser);
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
                // _buildActionButton(
                //     ChatMenuAction.share,
                //     Icon(
                //       Icons.share,
                //       color: Colors.white,
                //     ),
                //     Colors.orange,
                //     shareText),
                _buildActionButton(
                    ChatMenuAction.reply,
                    Icon(
                      Icons.reply,
                      color: Colors.white,
                    ),
                    Colors.blue,
                    replyText),
                _buildActionButton(
                    chat.createdBy == model.currentUser.id
                        ? ChatMenuAction.delete
                        : ChatMenuAction.report,
                    Icon(
                      chat.createdBy == model.currentUser.id
                          ? Icons.delete
                          : Icons.flag,
                      color: Colors.red,
                    ),
                    primaryColor,
                    chat.createdBy == model.currentUser.id
                        ? deleteText
                        : reportText),
              ];
            });
      },
    );
  }
}
