import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/pages/community_page.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'CreateCommunityPage:';

class CreateCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _nameFieldController = TextEditingController();
    final _descriptionFieldController = TextEditingController();

    final snackBar = SnackBar(content: Text(emptyNameFieldsWarningText));

    _handleResult(MainModel model, StatusCode createCommunityResult) {
      switch (createCommunityResult) {
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Failed to create community'),
          ));
          break;
        case StatusCode.success:
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CommunityPage(community: model.lastAddedCommunity)),
              ModalRoute.withName('/'));
          break;
        default:
          print(
              '$_tag createCommunityResult statusCode is: $createCommunityResult');
      }
    }

    _hanldeCommunityWithoutImage(MainModel model, Community community) async {
      final createCommunityStatus =
          await model.createCommunity(community, model.currentUser);
      _handleResult(model, createCommunityStatus);
    }

    _handleCommuntyWithImage(MainModel model, Community community) async {
      final createCommunityStatus =
          await model.createCommunity(community, model.currentUser);
      if (createCommunityStatus == StatusCode.failed) {
        _handleResult(model, createCommunityStatus);
        return null;
      }

      _handleResult(model, createCommunityStatus);

      if (await model.uploadFile(FileUploadFor.community, community) ==
          StatusCode.success) model.joinCommunity(community, model.currentUser);
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
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        // textInputAction: TextInputAction.done,
        controller: _nameFieldController,
        decoration: InputDecoration(hintText: communityNameText),
      ),
    );

    final _descriptionField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _descriptionFieldController,
        maxLines: null,
        decoration: InputDecoration(hintText: communityDescriptionText),
      ),
    );

    Widget _fieldsSection(BuildContext context) => Column(
          children: <Widget>[_nameField, _descriptionField],
        );

    final _submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
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
      // resizeToAvoidBottomPadding: false,
      appBar: _appBar,
      body: _body,
    );
  }
}
