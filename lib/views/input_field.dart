import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/utils/strings.dart';

class InputFieldView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _chatFieldController = new TextEditingController();
    var _hasMessage = false;

    _processMessage() {}

    sendMessage() {
      //get text
      //check if text is empty
      //cleat text
      var message = _chatFieldController.text.trim();
      message.isNotEmpty ? _processMessage() : _hasMessage = false;
      /*_chatFieldController.clear()*/
      ;
      _chatFieldController.clear();
    }

    _openImagePicker() {}

    return Material(
      elevation: 4.0,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () => _openImagePicker,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _chatFieldController,
//                onChanged: (){},
                      autofocus: false,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: messageText,
                      ),
                    ),
                  ),
//                  IconButton(
//                    onPressed: _hasMessage ? sendMessage : null,
//                    icon: Icon(Icons.send),
//                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text(sendText),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
