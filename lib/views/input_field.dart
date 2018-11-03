import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
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
          createdBy: model.currentUser.id,
          communityId: communityId,
        );
        _chatFieldController.text = '';

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
          icon:
          /*model.sendingMessageStatus == StatusCode.waiting
              ? MyProgressIndicator(
                  size: 15.0,
                  color: primaryColor,
                )
              :*/
          Icon(Icons.send),
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

//    _handleJoinCommunity(MainModel model) async {
//      final joinCommunityResult =
//          await model.joinCommunity(communityId, model.currentUser.id);
//      if (joinCommunityResult == StatusCode.failed)
//        Scaffold.of(context)
//            .showSnackBar(SnackBar(content: Text(failedToJoinCommunityText)));
//    }

//    final _joinButton =
//        ScopedModelDescendant<MainModel>(builder: ((context, child, model) {
//      return RaisedButton(
//        onPressed: () => model.joiningCommunityStatus == StatusCode.waiting
//            ? null
//            : _handleJoinCommunity(model),
//        child: model.joiningCommunityStatus == StatusCode.waiting
//            ? MyProgressIndicator(
//                color: Colors.white,
//                size: 15.0,
//              )
//            : Text(joinText),
//        color: primaryColor,
//        textColor: Colors.white,
//      );
//    }));

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
                        : JoinButtonView(
                        communityId: communityId); //_joinButton;
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
