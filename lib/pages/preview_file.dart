import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/colors.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';

import 'package:scoped_model/scoped_model.dart';

class PreviewFilePage extends StatelessWidget {
  final AddMenuOption option;

  const PreviewFilePage({Key key, this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _previewImage() {
      return ScopedModelDescendant<MainModel>(
          builder: (_, __, model) => Image.file(model.imageFile));
    }

    final _previewSection = Center(
      child: /*option == AddMenuOption.video ? _previewVideo(_controller) : */ _previewImage(),
    );

    final _sendButton = IconButton(
      icon: Icon(
        Icons.send,
        color: primaryColor,
      ),
      onPressed: () {},
    );

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
                  child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: _sendButton,
                        border: InputBorder.none,
                        hintText: addCaptionText,
                        prefixIcon: Icon(Icons.message)),
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
