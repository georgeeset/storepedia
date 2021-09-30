import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photomanager_event.dart';
part 'photomanager_state.dart';

class PhotomanagerBloc extends Bloc<PhotomanagerEvent, PhotomanagerState> {
   PhotomanagerBloc() : super(PhotomanagerEmptyState());

  @override
  Stream<PhotomanagerState> mapEventToState(
    PhotomanagerEvent event,
  ) async* {
    
    if(event is SelectPhotoEvent){
      yield(ImageSelectedState(image: event.photo));
    }
    
    if(event is RemovePhotoEvent){
      yield(PhotomanagerEmptyState());
    }
  }
@override
  void onChange(Change<PhotomanagerState> change) {
    print('Image manager State change ${change.nextState}');
    super.onChange(change);
  }
@override
  void onEvent(PhotomanagerEvent event) {
    print('Image manager Event ${event.toString()}');
    super.onEvent(event);
  }
}
