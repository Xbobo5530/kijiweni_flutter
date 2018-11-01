import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/utils/strings.dart';

class CreateCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _nameFieldController = TextEditingController();
    final _descriptionFieldController = TextEditingController();

    final _appBar = AppBar(
      title: Text(createCommunityText),
      backgroundColor: Colors.lightGreen,
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
            Icons.add_a_photo,
            size: 50.0,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: Colors.lightGreen, shape: BoxShape.circle),
        ),
      ),
    );

    final _nameField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: communityNameText),
      ),
    );

    final _descriptionField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextField(
        maxLines: 5,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: communityDescriptionText),
      ),
    );

    final _fieldsSection = Column(
      children: <Widget>[_nameField, _descriptionField],
    );
    final _submitButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              color: Colors.lightGreen,
              child: Text(submitText),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: _appBar,
      body: ListView(
        children: <Widget>[
          _imageSection,
          _fieldsSection,
          _submitButton,
        ],
      ),
    );
  }
}
