import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  MyProgressIndicator({@required this.size, @required this.color});

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
