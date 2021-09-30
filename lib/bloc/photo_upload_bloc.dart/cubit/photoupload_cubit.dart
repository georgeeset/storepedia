import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store_pedia/repository/photo_manager_repository.dart';

part 'photoupload_state.dart';

class PhotouploadCubit extends Cubit<PhotouploadState> {
  

  
  final PhotoManagerRepository photoManagerRepository= PhotoManagerRepository();

  PhotouploadCubit() : super(PhotouploadInitial());
  
  attemptUpload({required File photo}){
     var upload= photoManagerRepository.uploadItemImage(image:photo);
      upload.listen((taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        taskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          emit(PhotouploadedState(uploadLink: downloadUrl));
        },);
      }
      if(taskSnapshot.state == TaskState.running){
        emit(PhotouploadingState(percentage: ((taskSnapshot.bytesTransferred*100)/taskSnapshot.totalBytes),),);
      }
     
    }).onError((error){
      emit(PhotouploadErrorState(message: error.toString()));
    });
    
  }
  
  @override
  void onError(Object error, StackTrace stackTrace) {
    print('Error at PhotoUploadBloc ${error.toString} stackTrace: $stackTrace');
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<PhotouploadState> change) {
    print('PhotoUploadBloc State ${change.nextState}');
    super.onChange(change);
  }

  // @override
  // Future<void> close() {
  //   photoSubscription.cancel();
  //   scoreSubscription.cancel();
  //   return super.close();
  // }
}
