import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:kijiweni_flutter/models/main_model.dart';
import 'package:kijiweni_flutter/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ReceivedChatBubbleView extends StatefulWidget {
  final Chat chat;

  ReceivedChatBubbleView({Key key, this.chat}) : super(key: key);

  @override
  _ReceivedChatBubbleViewState createState() => _ReceivedChatBubbleViewState();
}

class _ReceivedChatBubbleViewState extends State<ReceivedChatBubbleView> {
  User _user;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getUser(MainModel model) async {
      final user = await model.userFromId(widget.chat.createdBy);
      if (!_isDisposed)
        setState(() {
          _user = user;
        });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ScopedModelDescendant<MainModel>(builder: (context, child, model) {
            _getUser(model);

            return Column(
              children: <Widget>[
                ListTile(
                  subtitle: _user != null ? Text(_user.name) : Container(),
                ),
                _user == null
                    ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 42.0,
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                      _user.imageUrl,
                    ),
                  ),
                )
              ],
            );
          }),
          Container(
              child: Text(widget.chat.message),
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(5.0),
                ),
              )),
        ],
      ),
    );
  }
}
