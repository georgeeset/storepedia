part of 'partquerymanager_cubit.dart';

abstract class PartquerymanagerState extends Equatable {
  const PartquerymanagerState();

  @override
  List<Object> get props => [];
}

class PartquerymanagerInitialState extends PartquerymanagerState {
  @override
  String toString() {
    return 'PartquerymanagerInitialState';
  }
}

class PartqueryloadingState extends PartquerymanagerState{
  @override
  String toString() {
    return 'Partqueryloadingstate';
  }
}

class PartqueryloadedState extends PartquerymanagerState{
  final List<Part>response;
  PartqueryloadedState({required this.response});
  
  @override
  String toString() {
    return 'PartqueryloadedState';
  }

  @override
  List<Object> get props => [response];
}

class NopartfoundState extends PartquerymanagerState{

  @override
  String toString() {
    return 'NopartfoundState';
  }
}

class PartqueryerrorState extends PartquerymanagerState{
  const PartqueryerrorState({required this.message, this.stackTrace});
 final String message;
 final StackTrace? stackTrace;

 @override
  String toString() {
    return 'PartqueryerrorState';
  }
}
