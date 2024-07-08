part of 'photomanager_bloc.dart';

abstract class PhotomanagerEvent extends Equatable {
  const PhotomanagerEvent();

  @override
  List<Object> get props => [];
}

class SelectPhotoEvent extends PhotomanagerEvent {
  final dynamic photo;
  const SelectPhotoEvent({required this.photo});

  @override
  String toString() {
    return 'SelectPhotoEvent';
  }

  @override
  List<Object> get props => [];
}

class RemovePhotoEvent extends PhotomanagerEvent {
  @override
  String toString() {
    return 'RemovePhotoEvent';
  }
}
