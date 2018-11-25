import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  MyProgressIndicator({this.size = 60.0,  this.color = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Theme(
        child: CircularProgressIndicator(),
        data: Theme.of(context).copyWith(accentColor: color),
      ),
    );
  }
}
