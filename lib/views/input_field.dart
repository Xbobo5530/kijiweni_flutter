import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'InputFieldView:';

class InputFieldView extends StatelessWidget {
  final String communityId;

  InputFieldView({this.communityId});

  @override
  Widget build(BuildContext context) {
    final _chatFieldController = TextEditingController();

    _openImagePicker() {
      //todo handle adding image
    }

    _handleSendingMessageResult(StatusCode code) {
      switch (code) {
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(failedToSendMessageText)));
          break;
        default:
          _chatFieldController.text = '';
          print(
              '$_tag at _handleSendingMessageResult, the send message status code is $code');
      }
    }

    _sendMessage(MainModel model) async {
      if (_chatFieldController.text
          .trim()
          .isNotEmpty) {
        final message = _chatFieldController.text.trim();
        final chat = Chat(
          message: message,
          createdBy: model.currentUser.userId,
          communityId: communityId,
        );

        StatusCode sendMessageStatus = await model.sendMessage(chat);
        _handleSendingMessageResult(sendMessageStatus);
      }
    }

    final _addImageButton = IconButton(
      icon: Icon(Icons.add_a_photo),
      onPressed: () => _openImagePicker,
    );

    final _sendButton = ScopedModelDescendant<MainModel>(
      builder: ((context, child, model) {
        return IconButton(
          onPressed: () => _sendMessage(model),
          icon: model.sendingMessageStatus == StatusCode.waiting
              ? MyProgressIndicator(
            size: 15.0,
            color: primaryColor,
          )
              : Icon(Icons.send),
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
              child: _messageField,
            ),
          ],
        ),
      ),
    );
  }
}
