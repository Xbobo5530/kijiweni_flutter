import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyHomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _exploreButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return InkWell(
          onTap: () => model.setSelectedNavItem(1),
          child: Column(
            children: <Widget>[
              Container(
                width: 150.0,
                height: 150.0,
                child: Icon(Icons.search, size: 80.0),
                decoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
              ListTile(
                title: Text(
                  exploreHint,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );

    final _createButton = Column(
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          child: Icon(
            Icons.group_add,
            size: 80.0,
          ),
          decoration:
          BoxDecoration(color: Colors.lightGreen, shape: BoxShape.circle),
        ),
        ListTile(
            title: Text(
              createHint,
              textAlign: TextAlign.center,
            )),
      ],
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[_exploreButton, _createButton],
      ),
    );
  }
}
