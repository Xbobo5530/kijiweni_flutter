import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class UserDetailsSectionView extends StatelessWidget {
  final User user;
  final bool isMe;

  const UserDetailsSectionView({Key key, this.isMe = false, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _editController = TextEditingController();

    _getCurrentData(DetailType type) {
      switch (type) {
        case DetailType.name:
          return user.name;
          break;
        case DetailType.bio:
          return user.bio != null ? user.bio : bioText;
          break;
        default:
          return editText;
      }
    }

    Future<bool> _handleEditDialog(DetailType type) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(editText),
              content: TextField(
                maxLines: type == DetailType.name ? 1 : null,
                controller: _editController,
                decoration: InputDecoration(hintText: _getCurrentData(type)),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(cancelText),
                  textColor: Colors.grey,
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text(submitText),
                  textColor: Colors.green,
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));

    _getEditedUser(DetailType type, String newData) {
      switch (type) {
        case DetailType.name:
          user.name = newData;
          return user;
          break;
        case DetailType.bio:
          user.bio = newData;
          return user;
          break;
        default:
          print('error on type: $type');
          return user;
      }
    }

    _showEditDialog(MainModel model, DetailType detailType) async {
      bool startEditing = await _handleEditDialog(detailType);
      if (!startEditing) return null;
      final String newData = _editController.text.trim();
      if (newData.isEmpty) return null;
      User editedUser = _getEditedUser(detailType, newData);
      StatusCode editStatus =
          await model.editAccountDetails(editedUser, detailType);
      if (editStatus == StatusCode.failed) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }

    _buildEditButton(DetailType type) => ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black12,
              ),
              onPressed: () => _showEditDialog(model, type),
            ));

    final _bioSection = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isMe
              ? SizedBox(
                  width: 40,
                )
              : Container(),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.4),
            child: Text(
              user.bio != null ? user.bio : bioText,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          isMe ? _buildEditButton(DetailType.bio) : Container()
        ]);

    final _titleSection =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      isMe
          ? SizedBox(
              width: 40,
            )
          : Container(),
      Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
        child: Text(
          user.name,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      isMe ? _buildEditButton(DetailType.name) : Container(),
    ]);

    return Column(

      children: <Widget>[
        _titleSection,
        _bioSection,
      ],
    );
  }
}
