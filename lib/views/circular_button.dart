import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double size;
  final double elevation;
  final Color color;
  
  /// Typically a [Widget] of type [Icon]
  /// but can be replaced with any other appropriate [Widget]
  /// like a [CircularProgressIndicator] or a layout [Widget]
  /// like a [Center]
  final Widget icon;

  const CircularButton(
      {Key key,
      this.size = 150.0,
      this.elevation = 4.0,
      this.color = Colors.lightGreen,
      this.icon = const Icon(
        Icons.people,
        size: 80.0,
      )})
      : assert(size != null),
        assert(elevation != null),
        assert(color != null),
        assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      elevation: elevation,
      child: Container(
        width: size,
        height: size,
        child: icon,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
