part of 'signinoption_bloc.dart';

abstract class SigninoptionEvent extends Equatable {
  const SigninoptionEvent();

  @override
  List<Object> get props => [];
}

class RegisterOptionEvent extends SigninoptionEvent {
  @override
  String toString() {
    return 'RegisterOptionEvent';
  }

  @override
  List<Object> get props => super.props;
}

class ForgotPasswordEvent extends SigninoptionEvent {
  @override
  String toString() {
    return 'ForgotPasswordEvent';
  }

  @override
  List<Object> get props => super.props;
}

class SigninEvent extends SigninoptionEvent {
  @override
  String toString() {
    return 'SigninEvent';
  }

  @override
  List<Object> get props => super.props;
}
