import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/labeled_circular_button.dart';

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(APP_NAME)),
      body: Center(
          child: Column(
        children: <Widget>[
          LabeledCircularButton(
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
            label: '$errorMessage\n$backHomeText',
            circularButton: CircularButton(
              elevation: 0,
              icon: Icon(
                Icons.error,
                size: 80,
              ),
              color: Colors.red,
            ),
          ),
        ],
      )),
    );
  }
}