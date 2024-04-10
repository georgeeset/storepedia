part of 'repitition_cubit.dart';

abstract class RepititionCubitState extends Equatable {
  const RepititionCubitState();

  @override
  List<Object> get props => [];
}

class RepititionInitialState extends RepititionCubitState {
  @override
  List<Object> get props => [];
  @override
  String toString() {
    return 'RepititionCubitInitial';
  }
}

class RepititionFoundState extends RepititionCubitState {
  RepititionFoundState({required this.partsFound});
  final List<Part> partsFound;

  @override
  List<Object> get props => [partsFound];
  @override
  String toString() {
    return 'RepititionFoundState';
  }
}

class RepititionNotFoundState extends RepititionCubitState{

  @override
  List<Object> get props => [];
  
  @override
  String toString() {
    return 'RepititionNotFoundState';
  }
}

class RepititionSearchError extends RepititionCubitState{
  RepititionSearchError({required this.errorMessage, this.stackTrace});
  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'RepititionSearchError';
  }
}