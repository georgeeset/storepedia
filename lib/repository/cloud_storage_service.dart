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
    required String filePath,

    /// reference to Uint8List if the data is in memory
    ///
    Uint8List? data,

    /// file location of file you want to replace
    String? replaceFileName,
  }) {
    /// this holds the final path where the file will be stored
    /// based on other information like replaceFileName
    var filePathLogical;
    if(replaceFileName!=null){
      Reference storageReference = _storage.refFromURL(replaceFileName);
      filePathLogical=storageReference.fullPath.toString();
     // print(filePathLogical);
    }else{
      filePathLogical=filePath;
    }
    if( file != null){
      return _storage.ref().child(filePathLogical).putFile(file);
    }else{
      if(data!=null){return _storage.ref().child(filePathLogical).putData(data);}
      else{
        return throw('Both data and file can\'t be null');
      }
    } 
    
        
  }

  Stream<TaskSnapshot> uploadTask() {
    return _uploadTask.snapshotEvents;
  }

  Future<void> deleteFile(String link) async {
    Reference storageReference = _storage.refFromURL(link);
    storageReference.delete();
  }
}
