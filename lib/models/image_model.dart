import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ImageModel:';

abstract class ImageModel extends Model {
  Future<File> getFile(AddMenuOption option) async {
    print('$_tag at getFile');
    switch (option) {
      case AddMenuOption.camera:
        return await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case AddMenuOption.image:
        return await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
      default:
        print('$_tag the selected option was: $option');
        return null;
    }
  }
}
