import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';

class PreviewPage extends StatelessWidget {
  final AddMenuOption option;

  const PreviewPage({Key key, this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _previewImage() {
      return ScopedModelDescendant<MainModel>(
          builder: (_, __, model) => FutureBuilder<File>(
              future: model.getFile(option),
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Image.file(snapshot.data);
                } else if (snapshot.error != null) {
                  return const Text(
                    'Error picking image.',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
              }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: Center(
        child: /*option == AddMenuOption.video ? _previewVideo(_controller) : */ _previewImage(),
      ),
    );
  }
}
