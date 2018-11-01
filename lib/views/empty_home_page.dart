import 'package:flutter/material.dart';

class EmptyHomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _exploreButton = Container(
      width: 150.0,
      height: 150.0,
      child: Icon(Icons.search, size: 80.0),
      decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
    );

    final _createButton = Container(
      width: 150.0,
      height: 150.0,
      child: Icon(
        Icons.group_add,
        size: 80.0,
      ),
      decoration:
          BoxDecoration(color: Colors.lightGreen, shape: BoxShape.circle),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[_exploreButton, _createButton],
      ),
    );
  }
}
