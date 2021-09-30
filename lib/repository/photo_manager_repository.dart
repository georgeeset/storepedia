import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:store_pedia/constants/firebase_constants.dart' as FirebaseConstants;
import 'package:store_pedia/repository/cloud_storage_service.dart';


class PhotoManagerRepository{
    CloudStorageService cloudStorageService=CloudStorageService();

  Stream<TaskSnapshot> uploadItemImage({required File image}){
    String name=DateTime.now().millisecondsSinceEpoch.toString();
    String extension=Path.basename(image.path);
    UploadTask task =cloudStorageService.startUpload(filePath:'${FirebaseConstants.storageLocation}/$name.$extension', file:image,);
    return task.snapshotEvents;
  }

  Future<void>deleteFile({required String targetFileLink}){
      return cloudStorageService.deleteFile(targetFileLink);
  }


}