import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/joined_list_item.dart';
import 'package:kijiweni_flutter/src/views/user_details_section.dart';
import 'package:kijiweni_flutter/src/views/user_image_section.dart';
import 'package:scoped_model/scoped_model.dart';

class UserProfileView extends StatelessWidget {
  final User user;
  final bool isMe;

  const UserProfileView({Key key, @required this.user, this.isMe = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userCommunitiesSection = ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => model.cachedJoinedCommunities.length == 0
            ? Container()
            : ExpansionTile(
                title: Text(user.id == model.currentUser.id
                    ? myCommunitiesText
                    : userCommunitiesText),
                leading: Chip(
                  label: Text('${model.cachedJoinedCommunities.length}'),
                ),
                children: model.cachedJoinedCommunities
                    .map((community) => JoinedCommunityListItemView(
                          community: community,
                          key: Key(community.id),
                        ))
                    .toList(),
              ));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            UserImageSectionView(
              user: user,
              isMe: isMe,
            ),
            UserDetailsSectionView(
              user: user,
              isMe: isMe,
            ),
            _userCommunitiesSection,
          ],
        ),
      ),
    );
  }
}
