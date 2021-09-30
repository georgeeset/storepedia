part of 'email_textfield_cubit.dart';

abstract class EmailTextfieldState extends Equatable {
  const EmailTextfieldState();

  @override
  List<Object> get props => [];
}

class EmailTextfieldInitial extends EmailTextfieldState {}

class EmailTextfieldError extends EmailTextfieldState{
  final String message;
  EmailTextfieldError({required this.message}): super();
  @override
  String toString()=>'EmailTextFieldError';
  @override
  List<Object> get props=>[message];
}

class EmailTextfieldOk extends EmailTextfieldState{
  final String email;
  EmailTextfieldOk({required this.email}): super();
  @override
  String toString()=>'EmailTextFieldOk';
  @override
  List<Object> get props=>[email];
}
