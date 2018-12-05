import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';

class CommunityImageSectionView extends StatelessWidget {
  final Community community;

  const CommunityImageSectionView({Key key, this.community}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: community.imageUrl != null
            ? Center(
                child: CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.lightGreen,
                backgroundImage: NetworkImage(community.imageUrl),
              ))
            : CircularButton(
                size: 120,
                elevation: 0.0,
                icon: Icon(
                  Icons.people,
                  size: 70.0,
                ),
              ));
  }
}