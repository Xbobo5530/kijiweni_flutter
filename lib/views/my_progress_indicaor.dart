import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/utils/colors.dart';

class MyProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  MyProgressIndicator({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Theme(
        child: CircularProgressIndicator(),
        data: Theme.of(context).copyWith(accentColor: primaryColor),
      ),
    );
  }
}
