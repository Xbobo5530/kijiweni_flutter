import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/pages/picked_iamge.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/join_button.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'InputFieldView:';

class InputFieldView extends StatelessWidget {
  final String communityId;

  InputFieldView({this.communityId});

  @override
  Widget build(BuildContext context) {
    final _chatFieldController = TextEditingController();

    // _showOptionsMenu() {
    //   //todo handle adding image
    // }

    _handleSendingMessageResult(StatusCode code) {
      switch (code) {
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(failedToSendMessageText)));
          break;
        default:
          print(
              '$_tag at _handleSendingMessageResult, the send message status code is $code');
      }
    }

    _sendMessage(MainModel model) async {
      if (_chatFieldController.text.trim().isNotEmpty) {
        final message = _chatFieldController.text.trim();
        final chat = Chat(
          message: message,
          createdBy: model.currentUser.id,
          communityId: communityId,
        );
        _chatFieldController.text = '';

        StatusCode sendMessageStatus = await model.sendMessage(chat);
        _handleSendingMessageResult(sendMessageStatus);
      }
    }

    // _handlePickImage(MainModel model, AddMenuOption option) {
    //   switch(option){
    //     case video
    //   }
    // }

    final _addImageButton =PopupMenuButton<AddMenuOption>(
              onSelected: (option) => Navigator.push(context, 
              MaterialPageRoute(
                builder: (_)=> PreviewPage(option: option),
                fullscreenDialog: true
              )),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<AddMenuOption>>[
                    const PopupMenuItem(
                      value: AddMenuOption.camera,
                      child: Text(takePhotoText),
                    ),
                    const PopupMenuItem(
                      value: AddMenuOption.image,
                      child: Text(addImageText),
                    ),
                    const PopupMenuItem(
                      value: AddMenuOption.video,
                      child: Text(addVideoText),
                    ),
                  ],
              child: Icon(Icons.add),
            );

    final _sendButton = ScopedModelDescendant<MainModel>(
      builder: ((context, child, model) {
        return IconButton(
          onPressed: () => _sendMessage(model),
          icon: Icon(Icons.send),
        );
      }),
    );

    final _messageField = TextField(
      controller: _chatFieldController,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          labelText: messageText,
          border: OutlineInputBorder(),
          prefixIcon: _addImageButton,
          suffixIcon: _sendButton),
    );

    return Material(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ScopedModelDescendant<MainModel>(
                  builder: ((context, child, model) {
                return model.joinedCommunities.contains(communityId)
                    ? _messageField
                    : JoinButtonView(communityId: communityId); //_joinButton;
              })),
            ),
          ],
        ),
      ),
    );
  }
}
