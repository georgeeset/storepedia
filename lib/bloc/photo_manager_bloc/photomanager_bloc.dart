import 'dart:io';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'photomanager_event.dart';
part 'photomanager_state.dart';

class PhotomanagerBloc extends Bloc<PhotomanagerEvent, PhotomanagerState> {
  PhotomanagerBloc() : super(PhotomanagerEmptyState()) {
    // @override
    // Stream<PhotomanagerState> mapEventToState(
    //   PhotomanagerEvent event,
    // ) async* {

    on<SelectPhotoEvent>((event, emit) {
      emit(ImageSelectedState(image: event.photo));
    });

    on<RemovePhotoEvent>((event, emit) {
      emit(PhotomanagerEmptyState());
    });
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
