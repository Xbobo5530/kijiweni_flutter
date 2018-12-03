import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/chat.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/chat_action_menu.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/message_meta_section.dart';
import 'package:scoped_model/scoped_model.dart';


const _tag = 'ChatBubble:';
class ChatBubbleView extends StatelessWidget {
  final bool isMe;
  final Chat chat;

  const ChatBubbleView({Key key, this.isMe, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageSection = chat.fileType == FILE_TYPE_IMAGE
        ? chat.fileUrl != null
            ? Image.network(chat.fileUrl)
            : FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(
                    Icons.image,
                    size: 100.0,
                    color: Colors.black12,
                  ),
                ),
              )
        : Container();

    final _messageTextSection = chat.message != null && chat.message.isNotEmpty
        ? Text(
            chat.message,
            style: TextStyle(fontSize: 18.0),
            softWrap: true,
          )
        : Container();

    _buildReplyContent(MainModel model) => ListTile(
          title: chat.createdBy == model.currentUser.id
              ? Text(
                  youText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : chat.replyToUsername == null
                  ? Container()
                  : Text(
                      chat.replyToUsername,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
          subtitle: Text(
              chat.replyToMessage != null && chat.replyToMessage.isNotEmpty
                  ? chat.replyToMessage
                  : chat.fileType == FILE_TYPE_IMAGE ? photoText : ''),
        );

    final _replyingToView = Container(
      color: Colors.white70,
      child: ScopedModelDescendant<MainModel>(
          builder: (_, __, model){
          
          print('$_tag ');
          return
           ListTile(
                title: chat.replyToUserId == model.currentUser.id
                    ? Text(
                        youText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : chat.replyToUsername == null
                        ? Container()
                        : Text(
                            chat.replyToUsername,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                subtitle: Text(chat.replyToMessage != null &&
                        chat.replyToMessage.isNotEmpty
                    ? chat.replyToMessage
                    : chat.fileType == FILE_TYPE_IMAGE ? photoText : ''),
              );}),
    );

    Widget _buildMessageContent() {
      if (chat.replyingTo != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _replyingToView,
            _imageSection,
            _messageTextSection,
          ],
        );
      }
      if (chat.fileType == null)
        return Container(); //TODO: remove on flush data
      if (chat.message != null &&
          chat.message.isNotEmpty &&
          chat.fileType == FILE_TYPE_NO_FILE) return _messageTextSection;
      if (chat.fileType != FILE_TYPE_NO_FILE && chat.message == null ||
          chat.message.isEmpty) return _imageSection;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: _imageSection,
            ),
            _messageTextSection
          ]);
    }

    final _messageSection = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FittedBox(
        child: Container(
            constraints: BoxConstraints(
                minWidth: 60.0,
                maxWidth: //300.0
                    isMe
                        ? MediaQuery.of(context).size.width - 80
                        : MediaQuery.of(context).size.width - 120),
            child: _buildMessageContent(),
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: isMe ? sentMessageColor : receivedMessageColor,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(10.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(5.0),
                    ),
            )),
      ),
    );

    final _messageStack = Stack(
      children: <Widget>[
        _messageSection,
        MessageMetaSectionView(chat: chat),
      ],
    );
    final _usernameSection = FittedBox(
      // padding: const EdgeInsets.only(left: 4.0),
      // width: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          chat.username != null
              ? Text(
                  chat.username,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );

    final _actionMenu = ChatActionMenuView(
      color: isMe ? sentMessageColor : receivedMessageColor,
      chat: chat,
      key: Key(chat.id),
    );
    final _sentBubbleChildren = <Widget>[
      _actionMenu,
      _messageStack,
    ];

    final _userImageSection = chat.userImageUrl == null
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircularButton(
                size: 45.0, icon: Icon(Icons.person, size: 30.0)),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.lightGreen,
              backgroundImage: NetworkImage(
                chat.userImageUrl,
              ),
            ),
          );

    final _receivedBubbleChilren = <Widget>[
      _userImageSection,
      SizedBox(
        width: 8.0,
      ),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _usernameSection,
                _messageStack,
              ],
            ),
            ChatActionMenuView(
              color: receivedMessageColor,
              chat: chat,
              key: Key(chat.id),
            )
          ],
        ),
      )
    ];

    return Padding(
      padding: isMe
          ? const EdgeInsets.only(right: 8.0)
          : const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: isMe ? _sentBubbleChildren : _receivedBubbleChilren,
      ),
    );
  }
}
