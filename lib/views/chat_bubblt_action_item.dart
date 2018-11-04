import 'package:flutter/material.dart';

class ChatBubbleActionItemView extends StatelessWidget {
  final Color color;
  final GestureTapCallback onTap;
  final Icon icon;

  ChatBubbleActionItemView(
      {@required this.color, @required this.onTap, @required this.icon})
      : assert(color != null),
        assert(onTap != null),
        assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => onTap,
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: icon,
        ),
      ),
    );
  }
}
