import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kijiweni_flutter/models/chat.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kijiweni_flutter/utils/consts.dart';
import 'package:kijiweni_flutter/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ImageModel:';

abstract class FileModel extends Model {
  final FirebaseStorage _storage = FirebaseStorage();
  final Firestore _database = Firestore.instance;
  File _imageFile;
  File get imageFile => _imageFile;
  StatusCode _uploadStatus;
  StatusCode get uploadStatus => _uploadStatus;
  String _fileUrl;
  String get fileUrl => _fileUrl;
  String _filePath;
  String get filePath => _filePath;

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

  Future<StatusCode> uploadFile(Chat chat) async {
    print('$_tag at uploadFile');
    bool _hasError = false;
    final String uuid = Uuid().v1();

    final File file = _imageFile; //TODO: account for video files as well
    final StorageReference ref =
        _storage.ref().child(IMAGES_BUCKET).child('$uuid.jpg');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'kijiweni'},
      ),
    );

    /// TODO: monitor uploads
    //    _tasks.add(uploadTask);
    //  _task = uploadTask;

    StorageTaskSnapshot snapshot =
        await uploadTask.onComplete.catchError((error) {
      print('$_tag error on uploading recording: $error');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    _fileUrl = await snapshot.ref.getDownloadURL();
    _filePath = await snapshot.ref.getPath();
    //print('$_tag the download url is : $_fileUrl');

    notifyListeners();
    return await _updateChatWithFileUrl(chat);
  }

  Future<StatusCode> _updateChatWithFileUrl(Chat chat) async {
    print('$_tag at _updateChatWithFileUrl');
    bool _hasError = false;
    Map<String, dynamic> updateFileMap = {
      FILE_URL_FIELD: _fileUrl,
      FILE_PATH_FIELD: _filePath,
      FILE_STATUS_FIELD: FILE_STATUS_UPLOAD_SUCCESS
    };

    await _database
        .collection(COMMUNITIES_COLLECTION)
        .document(chat.communityId)
        .collection(CHATS_COLLECTION)
        .document(chat.id)
        .updateData(updateFileMap)
        .catchError((error) {
      print('$_tag error on updating chat with uploaded file: $error');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<StatusCode> deleteAsset(Chat chat) async {
    print('$_tag at deleteAsset');
    bool _hasError = false;
    _storage.ref().child(chat.filePath).delete().catchError((error) {
      print('$_tag error on deleting file');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }
}
