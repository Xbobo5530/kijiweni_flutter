import 'package:flutter/material.dart';

class InputFieldView extends StatefulWidget {
  @override
  _InputFieldViewState createState() => _InputFieldViewState();
}

class _InputFieldViewState extends State<InputFieldView> {
  var _chatFieldController = new TextEditingController();
  var _hasMessage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _openImagePicker,
            ),
            Expanded(
              child: TextField(
                controller: _chatFieldController,
                onChanged: _onMessageChanged,
                autofocus: false,
              ),
            ),
            IconButton(
              onPressed: _hasMessage ? sendMessage : null,
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  void _onMessageChanged(message) {
    if (message.isNotEmpty) {
      setState(() {
        _hasMessage = true;
      });
    } else {
      setState(() {
        _hasMessage = false;
      });
    }
  }

  void sendMessage() {
    //get text
    //check if text is empty
    //cleat text
    var message = _chatFieldController.text.trim();
    message.isNotEmpty ? _processMessage() : _hasMessage = false;
    /*_chatFieldController.clear()*/
    ;
    _chatFieldController.clear();
  }

  void _openImagePicker() {}

  _processMessage() {}
}
