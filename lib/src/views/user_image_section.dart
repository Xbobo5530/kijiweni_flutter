import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/models/main_model.dart';
import 'package:kijiweni_flutter/src/models/user.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:kijiweni_flutter/src/utils/strings.dart';
import 'package:kijiweni_flutter/src/views/circular_button.dart';
import 'package:kijiweni_flutter/src/views/my_progress_indicaor.dart';
import 'package:scoped_model/scoped_model.dart';

class UserImageSectionView extends StatelessWidget {
  final User user;
  final bool isMe;

  const UserImageSectionView({Key key, this.user, this.isMe = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    _handleUploadImage(MainModel model) async {
      StatusCode uploadStatus =
          await model.uploadFile(FileUploadFor.user, user);
      if (uploadStatus == StatusCode.failed)
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    final _userImage = user.imageUrl != null
        ? Center(
            child: CircleAvatar(
            radius: 70.0,
            backgroundColor: Colors.lightGreen,
            backgroundImage: NetworkImage(user.imageUrl),
          ))
        : CircularButton(
            size: 120,
            elevation: 0.0,
            icon: Icon(
              Icons.people,
              size: 70.0,
            ),
          );
    _buildAddImageButton(MainModel model) => isMe
        ? Positioned(
            right: MediaQuery.of(context).size.width / 4.2,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: model.uploadStatus == StatusCode.waiting
                  ? MyProgressIndicator(
                      size: 15,
                      color: Colors.black12,
                      strokewidth: 2,
                    )
                  : IconButton(
                      onPressed: model.imageFile == null
                          ? () => model.getFile(AddMenuOption.image)
                          : () => _handleUploadImage(model),
                      color: model.imageFile == null
                          ? Colors.black12
                          : Colors.green,
                      icon: Icon(model.imageFile == null
                          ? Icons.add_a_photo
                          : Icons.done),
                    ),
            ),
          )
        : Container();
    return ScopedModelDescendant<MainModel>(
        builder: (_, __, model) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Stack(children: <Widget>[
                  Center(
                    child: model.imageFile != null
                        ? Center(
                            child: CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Colors.lightGreen,
                            backgroundImage: FileImage(model.imageFile),
                          ))
                        : _userImage,
                  ),
                  _buildAddImageButton(model)
                ]),
              ),
            ));
  }
}
