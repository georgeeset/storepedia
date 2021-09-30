import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  late UploadTask _uploadTask;
  FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask startUpload({
    /// reference to file you want to uppload
    File? file,

    ///file location plus file name together plus file extension
    required String? filePath,

    /// reference to Uint8List if the data is in memory
    ///
    Uint8List? data,
  }) {
    return file != null
        ? _storage.ref().child(filePath!).putFile(file)
        : _storage.ref().child(filePath!).putData(data!);
  }

  Stream<TaskSnapshot> uploadTask() {
    return _uploadTask.snapshotEvents;
  }

  Future<void> deleteFile(String link) async {
    Reference storageReference = _storage.refFromURL(link);
    storageReference.delete();
  }
}
