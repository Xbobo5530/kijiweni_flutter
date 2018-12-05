import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';

class WaitingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(APP_NAME)),
      body: Center(child: MyProgressIndicator()),
    );
  }
}