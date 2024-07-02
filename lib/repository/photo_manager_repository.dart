import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:storepedia/constants/firebase_constants.dart'
    as firebase_constants;
import 'package:storepedia/repository/cloud_storage_service.dart';

class PhotoManagerRepository {
  CloudStorageService cloudStorageService = CloudStorageService();

  Stream<TaskSnapshot> uploadItemImage({
    required File image,

    ///fileName represent the file you want to overwrite.
    ///dont provide it if you dont need to.
    String? fileName,
  }) {
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    String extension = p.basename(image.path);
    UploadTask task = cloudStorageService.startUpload(
        filePath: '${firebase_constants.storageLocation}/$name.$extension',
        file: image,
        replaceFileName: fileName);
    return task.snapshotEvents;
  }

  Future<void> deleteFile({required String targetFileLink}) {
    return cloudStorageService.deleteFile(targetFileLink);
  }
}
