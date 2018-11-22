import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';

import 'package:kijiweni_flutter/pages/preview_file.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
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

    _handleSelectFileFromDevice(MainModel model, AddMenuOption option) async {
      StatusCode getFileStatus = await model.getFile(option);
      switch (getFileStatus) {
        case StatusCode.success:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PreviewFilePage(
                        option: option,
                      ),
                  fullscreenDialog: true));
          break;
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessageText)));
          break;
        default:
          print('$_tag unexpected get file status : $getFileStatus');
      }
    }

    final _addFileButton = ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => PopupMenuButton<AddMenuOption>(
              onSelected: (option) =>
                  _handleSelectFileFromDevice(model, option),
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
              child: Icon(Icons.add, color: primaryColor,),
            ));

    final _sendButton = ScopedModelDescendant<MainModel>(
      builder: ((context, child, model) {
        return IconButton(
          onPressed: () => _sendMessage(model),
          icon: Icon(Icons.send, color: primaryColor,),
        );
      }),
    );

    final _messageField = TextField(
      controller: _chatFieldController,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          hintText: messageText,
          border: InputBorder.none,
          prefixIcon: _addFileButton,
          suffixIcon: _sendButton),
    );



    // Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.all(Radius.circular(12.0)),
    //           color: Colors.white70,
    //         ),
    //         child: Row(
    //           children: <Widget>[
    //             Expanded(
    //               child: TextField(
    //                 decoration: InputDecoration(
    //                     suffixIcon: _sendButton,
    //                     border: InputBorder.none,
    //                     hintText: addCaptionText,
    //                     prefixIcon: Icon(Icons.message)),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white70,
              ),
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
