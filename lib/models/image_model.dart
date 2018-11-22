import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ImageModel:';

abstract class ImageModel extends Model {
  File _imageFile;
  File get imageFile => _imageFile;

  Future<StatusCode> getFile(AddMenuOption option) async {
    print('$_tag at getFile');
    bool _hasError = false;
    switch (option) {
      case AddMenuOption.camera:
        _imageFile = await ImagePicker.pickImage(source: ImageSource.camera)
            .catchError((error) {
          print('$_tag error on picking image from camera');
          _hasError = true;
        });
        notifyListeners();
        break;
      case AddMenuOption.image:
        _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery)
            .catchError((error) {
          print('$_tag error on picking image from camera');
          _hasError = true;
        });
        notifyListeners();
        break;
      default:
        print('$_tag the selected option was: $option');
        return null;
    }
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }
}
