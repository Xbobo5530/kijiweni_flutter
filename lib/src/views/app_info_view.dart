import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class AppInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _buildAppActionButton(String label, AppInfoAction action) => FlatButton(
          child: Text(label),
          onPressed: () => Navigator.pop(context, action),
        );

    final _body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Text(
        developedByText,
        style: TextStyle(fontSize: 16),
      ),
    );

    final _actions = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildAppActionButton(moreText, AppInfoAction.more),
        _buildAppActionButton(emailText, AppInfoAction.email),
        _buildAppActionButton(callText, AppInfoAction.call),
      ],
    );

    Future<AppInfoAction> _showDialog() => showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text(APP_NAME),
              children: <Widget>[_body, _actions],
            ));

    _showAppInfoDialog(MainModel model) async {
      AppInfoAction action = await _showDialog();
      model.handleAppInfoAction(action);
    }

    return ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => IconButton(
              icon: Icon(Icons.forum),
              onPressed: () => _showAppInfoDialog(model),
            ));
  }
}
