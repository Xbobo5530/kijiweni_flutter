import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';

class LabeledCircularButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final CircularButton circularButton;
  final String label;

  const LabeledCircularButton(
      {Key key, this.onTap, this.circularButton, @required this.label})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          circularButton,
          ListTile(
            title: Text(
              label,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
