import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';

import 'package:kijiweni_flutter/pages/preview_file.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/join_button.dart';
import 'package:kijiweni_flutter/views/reply_message.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'InputFieldView:';

class InputFieldView extends StatelessWidget {
  final Community community;

  InputFieldView({this.community});

  @override
  Widget build(BuildContext context) {
    final _chatFieldController = TextEditingController();

    // _showOptionsMenu() {
    //   //todo handle adding image
    // }

    _handleSendingMessageResult(MainModel model, StatusCode code) {
      switch (code) {
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(failedToSendMessageText)));
          break;
        case StatusCode.success:
          model.updateListViewPosition();
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
            communityId: community.id,
            fileType: FILE_TYPE_NO_FILE,
            fileStatus: FILE_STATUS_NO_FILE,
            createdAt: DateTime.now().millisecondsSinceEpoch);
        _chatFieldController.text = '';

        StatusCode sendMessageStatus =
            await model.sendMessage(chat, model.currentUser, community);
        _handleSendingMessageResult(model, sendMessageStatus);
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
                        community: community,
                        uploadFor: FileUploadFor.chat,
                      ),
                  fullscreenDialog: true));
          break;
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
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
                    // const PopupMenuItem(
                    //   value: AddMenuOption.video,
                    //   child: Text(addVideoText),
                    // ),
                  ],
              child: Icon(
                Icons.add,
                color: primaryColor,
              ),
            ));

    final _sendButton = ScopedModelDescendant<MainModel>(
      builder: ((context, child, model) {
        return IconButton(
          onPressed: () => _sendMessage(model),
          icon: Icon(
            Icons.send,
            color: primaryColor,
          ),
        );
      }),
    );

    final _messageField = TextField(
      controller: _chatFieldController,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          hintText: messageText,
          border: InputBorder.none,
          prefixIcon: _addFileButton,
          suffixIcon: _sendButton),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Colors.white70,
        ),
        child: ScopedModelDescendant<MainModel>(
          builder: (_, __, model) => Column(children: <Widget>[
                model.isReplying
                    ? ReplyMessageView()
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: model.joinedCommunities.containsKey(community.id)
                            ? _messageField
                            : JoinButtonView(community: community)),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
