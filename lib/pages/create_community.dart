import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/community.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:kijiweni_flutter/views/circular_button.dart';
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

    _hanldeCommunityWithoutImage(MainModel model, Community community) async {
      final createCommunityStatus =
          await model.createCommunity(community, model.currentUser);
      _handleResult(createCommunityStatus);
    }

    _handleCommuntyWithImage(MainModel model, Community community) async {
      final createCommunityStatus =
          await model.createCommunity(community, model.currentUser);
      if (createCommunityStatus == StatusCode.failed) {
        _handleResult(createCommunityStatus);
        return null;
      }

      _handleResult(createCommunityStatus);

      if (await model.uploadFile(FileUploadFor.community, community) ==
          StatusCode.success) model.updateJoinedCommunities(model.currentUser);
    }

    _submitNewCommunity(MainModel model, BuildContext context) async {
      final name = _nameFieldController.text.trim();
      final description = _descriptionFieldController.text.trim();
      if (name.isEmpty)
        Scaffold.of(context).showSnackBar(snackBar);
      else {
        final community = Community(
            name: _nameFieldController.text.trim(),
            createdBy: model.currentUser.id,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            description: description.isNotEmpty
                ? _descriptionFieldController.text.trim()
                : null);

        model.imageFile != null
            ? _handleCommuntyWithImage(model, community)
            : _hanldeCommunityWithoutImage(model, community);
      }
    }

    final _appBar = AppBar(
      title: Text(createCommunityText),
    );

    _buildImageSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModelDescendant<MainModel>(
            builder: (_, __, model) => model.imageFile == null
                ? CircularButton(
                    icon: Icon(Icons.add_photo_alternate, size: 80),
                    onTap: () => model.getFile(AddMenuOption.image),
                  )
                : Center(
                    child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.lightGreen,
                        backgroundImage: FileImage(model.imageFile),
                      ),
                      Positioned(
                        top: 0.0,
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Opacity(
                          opacity: 0.5,
                          child: CircularButton(
                            color: Colors.white10,
                            elevation: 0.0,
                            size: 120.0,
                            icon: Icon(Icons.add_photo_alternate, size: 80),
                            onTap: () => model.getFile(AddMenuOption.image),
                          ),
                        ),
                      ),
                    ],
                  ))));

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

    Widget _fieldsSection(BuildContext context) => Column(
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
            _buildImageSection(),
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
