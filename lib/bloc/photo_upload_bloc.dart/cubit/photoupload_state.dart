part of 'photoupload_cubit.dart';

abstract class PhotouploadState extends Equatable {
  const PhotouploadState();
  
  @override
  List<Object> get props => [];
}

class PhotouploadInitial extends PhotouploadState {
  @override
  String toString() {
    return 'PhotouploadInitial';
  }
}

class PhotouploadingState extends PhotouploadState{
  final double percentage;
  const PhotouploadingState({required this.percentage});

  @override
  String toString() {
    return 'PhotouploadingStte';
  }

  @override
  List<Object> get props => [percentage];
}

class PhotouploadedState extends PhotouploadState{
  final String uploadLink;
  const PhotouploadedState({required this.uploadLink});

  @override
  String toString() {
    return 'PhotouploadedState';
  }

  @override
  List<Object> get props => [uploadLink];
}

class PhotouploadErrorState extends PhotouploadState{
  final String message;
  PhotouploadErrorState({required this.message});

  @override
  String toString() {
    return 'PhotouploadErrorState';
  }

  @override
  List<Object> get props => [message];
}
