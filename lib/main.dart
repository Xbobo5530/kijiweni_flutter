import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/pages/home.dart';
import 'package:kijiweni_flutter/values/strings.dart';

void main() => runApp(new Kijiweni());

class Kijiweni extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: APP_NAME,
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new HomePage(),
    );
  }
}
