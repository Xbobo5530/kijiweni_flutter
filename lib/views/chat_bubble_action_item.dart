import 'package:flutter/material.dart';

class ChatBubbleActionItemView extends StatelessWidget {
  final Color color;

//  final GestureTapCallback onTap;
  final Icon icon;
  final String label;

  ChatBubbleActionItemView(
      {@required this.color,
      /*@required this.onTap,*/ @required this.icon,
      this.label})
      : assert(color != null),
        /*assert(onTap != null),*/
        assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: icon,
          ),
          label != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
