import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class ReplyMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildImageSection(MainModel model) => Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: model.replyingTo.fileType == FILE_TYPE_IMAGE &&
                  model.replyingTo.fileUrl != null
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    model.replyingTo.fileUrl,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
        );

    _buildUsenameSection(MainModel model) => FutureBuilder<User>(
          future: model.userFromId(model.replyingTo.createdBy),
          builder: (context, snapshot) => !snapshot.hasData
              ? Text(loadingText)
              : Text(
                  model.replyingTo.createdBy == model.currentUser.id
                      ? youText
                      : snapshot.data.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        );
    _buildMessageSection(MainModel model) => Text(
          model.replyingTo.message.isEmpty &&
                  model.replyingTo.fileType == FILE_TYPE_IMAGE
              ? photoText
              : '${model.replyingTo.message}',
          maxLines: 2,
        );

    _buildInfoSection(MainModel model) => Expanded(
          child: model.isReplying
              ? ListTile(
                  title: _buildUsenameSection(model),
                  subtitle: _buildMessageSection(model),
                  // trailing: 
                )
              : Container(),
        );
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => Row(
            children: <Widget>[
              _buildImageSection(model),
              _buildInfoSection(model),
              IconButton(icon: 
                  Icon(Icons.cancel, color: primaryColor,),
                  onPressed: ()=> model.cancelReplyMessage(),),
            ],
          ),
    );
  }
}
