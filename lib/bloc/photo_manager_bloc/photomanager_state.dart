part of 'photomanager_bloc.dart';

abstract class PhotomanagerState extends Equatable {
  const PhotomanagerState();

  @override
  List<Object> get props => [];
}

class PhotomanagerEmptyState extends PhotomanagerState {
  @override
  String toString() {
    return 'PhotomanagerEmptyState';
  }
}

class ImageSelectedState extends PhotomanagerState {
  final File image;
  const ImageSelectedState({required this.image});

  @override
  String toString() {
    return 'ImageSelectedState';
  }

  @override
  List<Object> get props => [image];
}
