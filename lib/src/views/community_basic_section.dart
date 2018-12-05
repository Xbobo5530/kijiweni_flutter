import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityDetailsSectionView extends StatelessWidget {
  final Community community;
  final bool isAdmin;

  const CommunityDetailsSectionView({Key key, this.community, this.isAdmin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _editController = TextEditingController();

    _getCurrentData(DetailType type) {
      switch (type) {
        case DetailType.name:
          return community.name;
          break;
        case DetailType.description:
          return community.description != null
              ? community.description
              : communityDescriptionText;
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

    _getEditedCommunity(DetailType type, String newData) {
      switch (type) {
        case DetailType.name:
          community.name = newData;
          return community;
          break;
        case DetailType.description:
          community.description = newData;
          return community;
          break;
        default:
          print('error on type: $type');
          return community;
      }
    }

    _showEditDialog(MainModel model, DetailType detailType) async {
      bool startEditing = await _handleEditDialog(detailType);
      if (!startEditing) return null;
      final String newData = _editController.text.trim();
      if (newData.isEmpty) return null;
      Community editedCommunity = _getEditedCommunity(detailType, newData);
      StatusCode editStatus =
          await model.editCommunityInfo(editedCommunity, detailType);
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

    final _descSection = community.description != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                isAdmin
                    ? SizedBox(
                        width: 40,
                      )
                    : Container(),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.4),
                  child: Text(
                    community.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                isAdmin ? _buildEditButton(DetailType.description) : Container()
              ])
        : Container();

    final _titleSection =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      isAdmin
          ? SizedBox(
              width: 40,
            )
          : Container(),
      Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
        child: Text(
          community.name,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      isAdmin ? _buildEditButton(DetailType.name) : Container(),
    ]);

    return Column(
      children: <Widget>[
        _titleSection,
        _descSection,
      ],
    );
  }
}
