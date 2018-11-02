import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CreateCommunityPage:';

class CreateCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _nameFieldController = TextEditingController();
    final _descriptionFieldController = TextEditingController();

    final snackBar = SnackBar(content: Text(emptyNameFieldsWarningText));

    _handleResult(StatusCode createCommunityResult) {
      switch (createCommunityResult) {
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Failed to create community'),
          ));
          break;
        case StatusCode.success:
          Navigator.pop(context);
          break;
        default:
          print(
              '$_tag createCommunityResult statusCode is: $createCommunityResult');
      }
    }

    _submitNewCommunity(MainModel model, BuildContext context) async {
      final name = _nameFieldController.text.trim();
      final description = _descriptionFieldController.text.trim();
      if (name.isEmpty)
        Scaffold.of(context).showSnackBar(snackBar);
      else {
        final community = Community(
            name: _nameFieldController.text.trim(),
            createdBy: model.currentUser.userId,
            createdAt: DateTime
                .now()
                .millisecondsSinceEpoch,
            description: description.isNotEmpty
                ? _descriptionFieldController.text.trim()
                : null);

        final createCommunityStatus = await model.createCommunity(community);
        _handleResult(createCommunityStatus);
      }
    }

    final _appBar = AppBar(
      title: Text(createCommunityText),
    );

    final _imageSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4.0,
        shape: CircleBorder(),
        child: Container(
          height: 150.0,
          width: 150.0,
          child: Icon(
            Icons.people,
            size: 80.0,
          ),
          decoration:
              BoxDecoration(color: Colors.lightGreen, shape: BoxShape.circle),
        ),
      ),
    );

    final _nameField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextField(
        controller: _nameFieldController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: communityNameText),
      ),
    );

    final _descriptionField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextField(
        controller: _descriptionFieldController,
        maxLines: 5,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: communityDescriptionText),
      ),
    );

    Widget _fieldsSection(BuildContext context) =>
        Column(
          children: <Widget>[_nameField, _descriptionField],
        );
    final _submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return RaisedButton(
                  onPressed: () => _submitNewCommunity(model, context),
                  textColor: Colors.white,
                  color: primaryColor,
                  child: model.createCommunityStatus == StatusCode.waiting
                      ? MyProgressIndicator(
                    size: 15.0,
                    color: Colors.white,
                  )
                      : Text(submitText),
                );
              },
            ),
          ),
        ],
      ),
    );

    final _body = Builder(
      builder: ((context) {
        return ListView(
          children: <Widget>[
            _imageSection,
            _fieldsSection(context),
            _submitButton,
          ],
        );
      }),
    );

    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }
}
