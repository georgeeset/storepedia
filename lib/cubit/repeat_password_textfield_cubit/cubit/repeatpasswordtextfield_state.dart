part of 'repeatpasswordtextfield_cubit.dart';

abstract class RepeatPasswordTextfieldState extends Equatable {
  const RepeatPasswordTextfieldState();

  @override
  List<Object> get props => [];
}

class RepeatPasswordTextfieldInitial extends RepeatPasswordTextfieldState {
  @override
  String toString() {
    return 'RepeatPasswordTextfieldInitial';
  }
}

class RepeatPasswordTextfieldError extends RepeatPasswordTextfieldState{
  final String message;
  RepeatPasswordTextfieldError({required this.message}):super();
  @override
  String toString()=>'RepeatPasswordTextfieldError';
  @override
  List<Object> get props=>[message];
}

class RepeatPasswordTextfieldOk extends RepeatPasswordTextfieldState{
  final String password;
  RepeatPasswordTextfieldOk({required this.password});
  @override
  String toString()=>'RepeatPasswordTextfieldOk';
  @override
  List<Object> get props=>[password];
}