import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';
import 'package:storepedia/constants/firebase_constants.dart'
    as firebase_constants;
import 'package:storepedia/repository/cloud_storage_service.dart';

class PhotoManagerRepository {
  CloudStorageService cloudStorageService = CloudStorageService();

  Stream<TaskSnapshot> uploadItemImage({
    required dynamic image,

    /// Company name connects to the location where files will be stored
    required String companyName,

    ///fileName represent the file you want to overwrite.
    ///dont provide it if you dont need to.
    String? fileName,
  }) {
    print("uploading ongoing");
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    if (image is File) {
      var extension = p.basename(image.path);
      UploadTask task = cloudStorageService.startUpload(
          filePath:
              '${firebase_constants.storageLocation}/$companyName/$name.$extension',
          file: image,
          replaceFileName: fileName);
      return task.snapshotEvents;
    } else {
      if (image is Uint8List) {
        var mime = lookupMimeType('', headerBytes: image);
        mime ??= 'image/jpeg';
        var extension = extensionFromMime(mime);
        UploadTask task = cloudStorageService.startUpload(
            filePath:
                '${firebase_constants.storageLocation}/$companyName/$name.$extension',
            data: image,
            replaceFileName: fileName);
        return task.snapshotEvents;
      }
    }
    throw ('PhotoManager Repository Error. Unsupported file type');
  }

  Future<void> deleteFile({required String targetFileLink}) {
    return cloudStorageService.deleteFile(targetFileLink);
  }
}
