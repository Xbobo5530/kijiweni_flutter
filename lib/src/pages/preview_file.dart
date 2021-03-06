import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/chat.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';

import 'package:scoped_model/scoped_model.dart';

const _tag = 'PreviewFilePage:';

class PreviewFilePage extends StatelessWidget {
  final AddMenuOption option;
  final Community community;
  final String message;
  final FileUploadFor uploadFor;

  const PreviewFilePage(
      {Key key,
      @required this.option,
      @required this.community,
      this.uploadFor,
      this.message})
      : assert(option != null),
        assert(community != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _captionController = TextEditingController();
    Widget _previewImage() => ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => model.imageFile == null
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: CircularButton(
                elevation: 0,
                icon: Icon(Icons.image, size: 80,),
              
              ),
            ),
            RaisedButton(
              child: Text(addImageText),
              onPressed: ()=> model.getFile(AddMenuOption.image),
            ),
            RaisedButton(
              child: Text(takePhotoText),
              onPressed: ()=> model.getFile(AddMenuOption.camera),
            )
          ],
        )
        : Image.file(model.imageFile));

    final _previewSection = Center(
      child: /*option == AddMenuOption.video ? _previewVideo(_controller) : */ _previewImage(),
    );

    int _getFileType() {
      switch (option) {
        case AddMenuOption.camera:
        case AddMenuOption.image:
          return FILE_TYPE_IMAGE;
          break;
        case AddMenuOption.video:
          return FILE_TYPE_VIDEO;
          break;
        default:
          print('$_tag unexpected add menu option: $option');
          return FILE_TYPE_NO_FILE;
      }
    }

    _handleSend(MainModel model) async {
      final caption = _captionController.text.trim();
      // if (caption.isEmpty) return null;
      Chat chat = Chat(
          message: caption,
          createdBy: model.currentUser.id,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          communityId: community.id,
          fileType: _getFileType(),
          fileStatus: FILE_STATUS_UPLOADING);

      StatusCode sendStatus =
          await model.sendMessage(chat, model.currentUser, community);
      switch (sendStatus) {
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
          break;
        case StatusCode.success:
          chat.id = model.latestChat.id;
          model.uploadFile(FileUploadFor.chat, chat);
          Navigator.pop(context);
          break;
        default:
          print('$_tag unexpected send status: $sendStatus');
      }
    }

    final _sendButton = ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => IconButton(
              icon: Icon(
                Icons.send,
                color: primaryColor,
              ),
              onPressed: () => _handleSend(model),
            ));

    _buildController(MainModel model) {
      if (message != null) {
        _captionController.text = message;
        return _captionController;
      }
      return _captionController;
    }

    final _captionSection = Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: Colors.white70,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ScopedModelDescendant<MainModel>(
                    builder: (_, __, model) => TextField(
                      maxLines: null,
                          controller: _buildController(model),
                          decoration: InputDecoration(
                              suffixIcon: _sendButton,
                              border: InputBorder.none,
                              hintText: addCaptionText,
                              prefixIcon: Icon(Icons.message)),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(APP_NAME),
      ),
      body: Stack(
        children: <Widget>[
          _previewSection,
          _captionSection,
        ],
      ),
    );
  }
}
