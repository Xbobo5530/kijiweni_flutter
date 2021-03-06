import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final double strokewidth;

  MyProgressIndicator({this.size = 60.0,  this.color = Colors.orange, this.strokewidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Theme(
        child: CircularProgressIndicator(strokeWidth: strokewidth,),
        data: Theme.of(context).copyWith(accentColor: color),
      ),
    );
  }
}
