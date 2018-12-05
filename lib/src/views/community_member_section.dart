import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/community.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/colors.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunityMemberSectionView extends StatelessWidget {
  final Community community;

  const CommunityMemberSectionView({Key key, this.community}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    Widget _buildMemberListItem(User member) {
      return ListTile(
        leading: member.imageUrl != null
            ? CircleAvatar(
                backgroundColor: green,
                backgroundImage: NetworkImage(member.imageUrl),
              )
            : CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 32,
                )),
        title: Text(member.name),
      );
    }
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => FutureBuilder<List<User>>(
            future: model.getCommunityMembersFor(community),
            initialData: <User>[],
            builder: (_, snapshot) => snapshot.data.length == 0
                ? Container()
                : ExpansionTile(
                    title: Text(membersText),
                    leading: Chip(
                      label: Text('${snapshot.data.length}'),
                    ),
                    children: snapshot.data.map(_buildMemberListItem).toList(),
                  ),
          ),
    );
  }
}